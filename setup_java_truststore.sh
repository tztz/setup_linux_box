#!/bin/bash

#
# Imports (merges) the REWE digital's certificates into the Java TrustStore (cacerts).
#
# The REWE root certificates can be downloaded from
#   - https://certs.rewe-group.com/RootCA/ and
#   - https://certs.rewe-group.com/SubCA/
#

backup_timestamp=$(date +%Y-%m-%d_%H-%M-%S)

#
# Overrides the original Java TrustStore (cacerts) with REWE digital's version.
#
# This is the old version which is replaced by the import_rewedigital_certs func (see below).
#
override_cacerts() {
    # Backup the original cacerts file
    mkdir -p $JAVA_HOME/lib/security/backups/ && \
    cp $JAVA_HOME/lib/security/cacerts $JAVA_HOME/lib/security/backups/cacerts.backup-${backup_timestamp} && \
    # Create a directory to hold the REWE digital certificates and copy them there
    rm -rf $JAVA_HOME/lib/security/rewedigital_certs/ && \
    mkdir -p $JAVA_HOME/lib/security/rewedigital_certs/ && \
    cp ~/mydata/auth_certificates_keys/rewedigital/java/cacerts/* $JAVA_HOME/lib/security/rewedigital_certs/ && \
    # Replace the original cacerts file with the modified copy containing the REWE digital certificates
    cp $JAVA_HOME/lib/security/rewedigital_certs/cacerts_rewedigital.cer $JAVA_HOME/lib/security/cacerts
}

#
# Creates a new Java TrustStore based on the original one (cacerts).
# The REWE digital certs are then imported into that new TrustStore.
# The new TrustStore is copied next to the original cacerts file.
# The original TrustStore (cacerts) is NOT modified!
#
import_rewedigital_certs() {
    local key_password="$1"

    # Backup the original cacerts file
    mkdir -p $JAVA_HOME/lib/security/backups/ && \
    cp $JAVA_HOME/lib/security/cacerts $JAVA_HOME/lib/security/backups/cacerts.backup-${backup_timestamp} && \
    # Create a directory to hold the REWE digital certificates and copy them there
    rm -rf $JAVA_HOME/lib/security/rewedigital_certs/ && \
    mkdir -p $JAVA_HOME/lib/security/rewedigital_certs/ && \
    cp ~/mydata/auth_certificates_keys/rewedigital/java/cacerts/* $JAVA_HOME/lib/security/rewedigital_certs/ && \
    # Create a copy of the original cacerts file to import the REWE digital certificates into
    cp $JAVA_HOME/lib/security/cacerts $JAVA_HOME/lib/security/rewedigital_certs/ && \
    # cd into the directory and import the REWE digital certificates into the copy of the original cacerts file
    cd $JAVA_HOME/lib/security/rewedigital_certs/ && \
    # Create a new TrustStore from the default one, delete old one if present
    rm -f ./rewedigital_truststore.p12 && \
    keytool -importkeystore -srckeystore cacerts -destkeystore rewedigital_truststore.p12 -srcstoretype PKCS12 -deststoretype PKCS12 -srcstorepass "${key_password}" -deststorepass "${key_password}" && \
    # Import the certificates we need into the newly created TrustStore
    keytool -import -alias RS_ROOTCA02 -keystore rewedigital_truststore.p12 -file ./RS_ROOTCA02.cer -trustcacerts -noprompt -storepass "${key_password}" && \
    keytool -import -alias "RS hosted DeviceCA06" -keystore rewedigital_truststore.p12 -file ./RS\ hosted\ DeviceCA06.cer -trustcacerts -noprompt -storepass "${key_password}" && \
    keytool -import -alias "RS_UserCA02" -keystore rewedigital_truststore.p12 -file RS_UserCA02.cer -trustcacerts -noprompt -storepass "${key_password}" && \
    keytool -import -alias "RS_MDMCA02" -keystore rewedigital_truststore.p12 -file RS_MDMCA02.cer -trustcacerts -noprompt -storepass "${key_password}" && \
    keytool -import -alias "RS_DeviceCA05" -keystore rewedigital_truststore.p12 -file RS_DeviceCA05.cer -trustcacerts -noprompt -storepass "${key_password}" && \
    keytool -import -alias "RS_DeviceCA04" -keystore rewedigital_truststore.p12 -file RS_DeviceCA04.cer -trustcacerts -noprompt -storepass "${key_password}" && \
    keytool -import -alias "RS_DeviceCA05 2" -keystore rewedigital_truststore.p12 -file RS\ DeviceCA05.cer -trustcacerts -noprompt -storepass "${key_password}" && \
    keytool -import -alias "RS_DeviceCA04 2" -keystore rewedigital_truststore.p12 -file RS\ DeviceCA04.cer -trustcacerts -noprompt -storepass "${key_password}" && \
    keytool -import -alias "RSCATest100" -keystore rewedigital_truststore.p12 -file RSCATest100.cer -trustcacerts -noprompt -storepass "${key_password}" && \
    keytool -import -alias "RSCA100" -keystore rewedigital_truststore.p12 -file RSCA100.cer -trustcacerts -noprompt -storepass "${key_password}" && \
    #keytool -import -alias "cacerts_rewedigital" -keystore rewedigital_truststore.p12 -file cacerts_rewedigital.cer -trustcacerts -noprompt -storepass "${key_password}" && \
    # Copy the new TrustStore next to the original one
    cp $JAVA_HOME/lib/security/rewedigital_certs/rewedigital_truststore.p12 $JAVA_HOME/lib/security/
}

delete_rewedigital_certs() {
    local key_password="$1"

    cd $JAVA_HOME/lib/security/ && \
    keytool -delete -alias RS_ROOTCA02 -keystore rewedigital_truststore.p12 -noprompt -storepass "${key_password}" && \
    keytool -delete -alias "RS hosted DeviceCA06" -keystore rewedigital_truststore.p12 -noprompt -storepass "${key_password}" && \
    keytool -delete -alias "RS_UserCA02" -keystore rewedigital_truststore.p12 -noprompt -storepass "${key_password}" && \
    keytool -delete -alias "RS_MDMCA02" -keystore rewedigital_truststore.p12 -noprompt -storepass "${key_password}" && \
    keytool -delete -alias "RS_DeviceCA05" -keystore rewedigital_truststore.p12 -noprompt -storepass "${key_password}" && \
    keytool -delete -alias "RS_DeviceCA04" -keystore rewedigital_truststore.p12 -noprompt -storepass "${key_password}" && \
    keytool -delete -alias "RS_DeviceCA05 2" -keystore rewedigital_truststore.p12 -noprompt -storepass "${key_password}" && \
    keytool -delete -alias "RS_DeviceCA04 2" -keystore rewedigital_truststore.p12 -noprompt -storepass "${key_password}" && \
    keytool -delete -alias "RSCATest100" -keystore rewedigital_truststore.p12 -noprompt -storepass "${key_password}" && \
    keytool -delete -alias "RSCA100" -keystore rewedigital_truststore.p12 -noprompt -storepass "${key_password}" && \
    rm -f $JAVA_HOME/lib/security/rewedigital_truststore.p12
}

###override_cacerts
import_rewedigital_certs "secret123"
#delete_rewedigital_certs "secret123"
