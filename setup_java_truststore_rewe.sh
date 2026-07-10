#!/bin/bash

#
# Imports (merges) the REWE digital's certificates into the Java TrustStore (cacerts).
# The original cacerts is backed up first (see the backups/ folder).
# The import is idempotent, so it can be re-run if the REWE certs are updated (e.g. new device CAs).
# The undo function restores the original cacerts from the backup, fully removing all REWE certs.
#
# Usage:
#    ./setup_java_truststore_rewe.sh [/path/to/java/home]
#
# If no argument is given, $JAVA_HOME is used by default.
#
# The REWE certs are expected to be found in ~/mydata/auth_certificates_keys/rewedigital/java/cacerts,
# which is not part of this repo.
#
# The REWE root certificates can be downloaded from
#   - https://certs.rewe-group.com/RootCA/ and
#   - https://certs.rewe-group.com/SubCA/
#
# In order to test whether the REWE certs are properly trusted, you can e.g. run a Maven build of a
# project with a dependency hosted on a REWE server (e.g. Artifactory) and see if it succeeds without
# SSL errors. Just compile it and set a fresh Maven local repository to avoid cached results and be
# sure the REWE certs are actually used:
#
#    mvn -Dmaven.repo.local=/tmp/m2repo clean compile
# 

# Accept an optional Java home path as the first argument; default to $JAVA_HOME.
JAVA_HOME_DIR="${1:-$JAVA_HOME}"

# Make sure the resolved Java home points to a real JDK before touching its cacerts.
# Without this guard, an unset/empty path would expand to paths like
# "/lib/security/cacerts" and operate on the wrong files.
if [[ -z "${JAVA_HOME_DIR}" || ! -d "${JAVA_HOME_DIR}/lib/security" ]]; then
    echo "Error: Java home is not set or '${JAVA_HOME_DIR}/lib/security' does not exist." >&2
    echo "Usage: $0 [/path/to/java/home]" >&2
    echo "If no path is given, JAVA_HOME is used (currently: '${JAVA_HOME:-<unset>}')." >&2
    exit 1
fi

echo "Going to operate on Java home: ${JAVA_HOME_DIR}"

backup_timestamp=$(date +%Y-%m-%d_%H-%M-%S)

#
# The stock Java cacerts TrustStore uses the well-known default password
# "changeit". It is used to read/modify the active cacerts. Shared by
# import_rewedigital_certs and undo_import_rewedigital_certs.
#
CACERTS_PASSWORD="changeit"

#
# Individual REWE certs handled by import/undo, as "alias|filename" pairs.
# Shared by import_rewedigital_certs and undo_import_rewedigital_certs so the
# two stay in sync.
#
REWE_CERTS=(
    "RS_ROOTCA02|RS_ROOTCA02.cer"
    "RS hosted DeviceCA06|RS hosted DeviceCA06.cer"
    "RS_UserCA02|RS_UserCA02.cer"
    "RS_MDMCA02|RS_MDMCA02.cer"
    "RS_DeviceCA05|RS_DeviceCA05.cer"
    "RS_DeviceCA04|RS_DeviceCA04.cer"
    "RS_DeviceCA05 2|RS DeviceCA05.cer"
    "RS_DeviceCA04 2|RS DeviceCA04.cer"
    "RSCATest100|RSCATest100.cer"
    "RSCA100|RSCA100.cer"
)

#
# Overrides the original Java TrustStore (cacerts) with REWE digital's version.
#
# This is the old version which is replaced by the import_rewedigital_certs func (see below).
#
# DO NOT USE THIS FUNCTION, it is left here for reference only.
#
#override_cacerts() {
#    # Backup the original cacerts file
#    mkdir -p $JAVA_HOME/lib/security/backups/ && \
#    cp $JAVA_HOME/lib/security/cacerts $JAVA_HOME/lib/security/backups/cacerts.backup-${backup_timestamp} && \
#    # Create a directory to hold the REWE digital certificates and copy them there
#    rm -rf $JAVA_HOME/lib/security/rewedigital_certs/ && \
#    mkdir -p $JAVA_HOME/lib/security/rewedigital_certs/ && \
#    cp ~/mydata/auth_certificates_keys/rewedigital/java/cacerts/* $JAVA_HOME/lib/security/rewedigital_certs/ && \
#    # Replace the original cacerts file with the modified copy containing the REWE digital certificates
#    cp $JAVA_HOME/lib/security/rewedigital_certs/cacerts_rewedigital.cer $JAVA_HOME/lib/security/cacerts
#}

#
# Creates a new Java TrustStore and installs it as the active cacerts so that
# tools using the default Java TrustStore (e.g. Maven) trust the REWE certs.
#
# The new TrustStore is built as follows:
#   1. Start from the proven, ready-made REWE bundle (cacerts_rewedigital.cer),
#      which already contains all REWE CAs.
#   2. Merge the JDK's own (stock) cacerts on top so the JDK's up-to-date public
#      CAs are kept too.
#   3. Import the individual REWE device/CA certs (.cer files) idempotently, in
#      case they are newer than what the bundle contains.
#
# IMPORTANT: the resulting TrustStore MUST be of type JKS, not PKCS12.
# The default JSSE trust store loader (used by Maven, java.net, etc.) reads
# cacerts with a *null* password. A keytool-built PKCS12 encrypts its entries and
# adds a MAC tied to the store password, so a null-password load yields ZERO
# entries -> "trustAnchors parameter must be non-empty". JKS trusted-cert entries
# are always readable with a null password, so JKS works as the default cacerts.
#
# The original cacerts is backed up first (see the backups/ folder).
#
import_rewedigital_certs() {
    local sec_dir="${JAVA_HOME_DIR}/lib/security"
    local src_certs_dir=~/mydata/auth_certificates_keys/rewedigital/java/cacerts
    local work_dir="${sec_dir}/rewedigital_certs"
    local new_store="rewedigital_truststore.jks"
    local pristine_backup="${sec_dir}/backups/cacerts.pristine"

    # Back up the PRISTINE cacerts exactly once. Subsequent imports must NOT
    # overwrite it: otherwise the backup would capture an already-modified
    # (REWE-containing) cacerts and undo could never fully restore the original.
    mkdir -p "${sec_dir}/backups/" || return 1
    if [[ ! -f "${pristine_backup}" ]]; then
        cp "${sec_dir}/cacerts" "${pristine_backup}" || return 1
    fi

    # Create a fresh working directory holding the REWE certificates
    rm -rf "${work_dir}" || return 1
    mkdir -p "${work_dir}" || return 1
    cp "${src_certs_dir}"/* "${work_dir}/" || return 1

    # Run keytool operations in a subshell to avoid changing the caller's CWD
    (
        cd "${work_dir}" || exit 1

        # 1. Start from the ready-made REWE bundle (JKS) as the base TrustStore.
        rm -f "./${new_store}" || exit 1
        cp ./cacerts_rewedigital.cer "./${new_store}" || exit 1

        # 2. Merge the JDK's stock public CAs on top. Use the PRISTINE cacerts (not
        #    the active one): after the first import the active cacerts is already the
        #    merged store, so merging it again would re-add its REWE certs under the
        #    bundle's own aliases and inflate the entry count -> not idempotent.
        #    -noprompt overwrites entries with matching aliases; bundle-only entries
        #    (the REWE CAs) are preserved.
        keytool -importkeystore \
            -srckeystore "${pristine_backup}" -srcstorepass "${CACERTS_PASSWORD}" \
            -destkeystore "./${new_store}" -deststoretype JKS -deststorepass "${CACERTS_PASSWORD}" \
            -noprompt || exit 1

        # 3. Import the individual REWE certs idempotently (delete any existing alias
        #    first so re-runs do not fail with "alias already exists").
        for entry in "${REWE_CERTS[@]}"; do
            cert_alias="${entry%%|*}"
            cert_file="${entry#*|}"
            keytool -delete -alias "${cert_alias}" -keystore "./${new_store}" \
                -storepass "${CACERTS_PASSWORD}" -noprompt >/dev/null 2>&1
            keytool -import -alias "${cert_alias}" -keystore "./${new_store}" -file "${cert_file}" \
                -trustcacerts -noprompt -storepass "${CACERTS_PASSWORD}" || exit 1
        done
    ) || return 1

    # Keep a copy of the new TrustStore next to the original one ...
    cp "${work_dir}/${new_store}" "${sec_dir}/" || return 1
    # ... and install it as the active cacerts so the default Java TrustStore
    # (used by Maven, etc.) actually trusts the REWE certs.
    cp "${work_dir}/${new_store}" "${sec_dir}/cacerts" || return 1
}

#
# Undoes what import_rewedigital_certs does:
#   - Restores the active cacerts from the pristine backup captured before the
#     first import (in the backups/ folder).
#   - Removes the generated truststore copies (working dir and next to cacerts).
#   - Removes the working directory with the copied REWE certificates.
#
undo_import_rewedigital_certs() {
    local sec_dir="${JAVA_HOME_DIR}/lib/security"
    local work_dir="${sec_dir}/rewedigital_certs"
    local new_store="rewedigital_truststore.jks"
    local pristine_backup="${sec_dir}/backups/cacerts.pristine"

    # Restore the pristine cacerts captured before the first import. This fully
    # removes EVERY REWE cert (including the bundle's own aliases such as
    # "reweroot" / "rs root ca02"), which a per-alias delete cannot reliably do
    # because the bundle's aliases differ from the .cer file aliases.
    if [[ -f "${pristine_backup}" ]]; then
        echo "Restoring pristine cacerts from ${pristine_backup}"
        cp "${pristine_backup}" "${sec_dir}/cacerts" || return 1
        # Drop the pristine backup; the active cacerts is clean again, so a later
        # import will re-capture a fresh pristine copy.
        rm -f "${pristine_backup}"
    else
        echo "Warning: no pristine cacerts backup found (${pristine_backup}); cacerts left unchanged." >&2
    fi

    # Remove the generated truststore copy placed next to cacerts ...
    rm -f "${sec_dir}/${new_store}"
    # ... and the working directory with the copied REWE certificates
    # (this also removes the working copy of the generated truststore).
    rm -rf "${work_dir}"
}

import_rewedigital_certs
#undo_import_rewedigital_certs
