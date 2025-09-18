#!/bin/bash

#
# Imports (merges) the REWE digital's certificates into the Java TrustStore (cacerts).
#
# The REWE root certificates can be downloaded from
#   - https://certs.rewe-group.com/RootCA/ and
#   - https://certs.rewe-group.com/SubCA/
#

backup_timestamp=$(date +%Y-%m-%d_%H-%M-%S)

# Backup the original cacerts file
cp $JAVA_HOME/lib/security/cacerts $JAVA_HOME/lib/security/cacerts.bakup-${backup_timestamp} && \
# Create a directory to hold the REWE digital certificates and copy them there
mkdir -p $JAVA_HOME/lib/security/rewedigital_certs/ && \
cp ~/mydata/auth_certificates_keys/rewedigital/java/cacerts/cacerts_rewedigital $JAVA_HOME/lib/security/rewedigital_certs/ && \
cp ~/mydata/auth_certificates_keys/rewedigital/java/cacerts/RS_ROOTCA02.cer $JAVA_HOME/lib/security/rewedigital_certs/ && \
cp ~/mydata/auth_certificates_keys/rewedigital/java/cacerts/RS\ hosted\ DeviceCA06.cer $JAVA_HOME/lib/security/rewedigital_certs/ && \
# Replace the original cacerts file with the modified copy containing the REWE digital certificates
cp $JAVA_HOME/lib/security/rewedigital_certs/cacerts_rewedigital $JAVA_HOME/lib/security/cacerts

#
# The below version does not work! Check someday why...
#

# Backup the original cacerts file
###cp $JAVA_HOME/lib/security/cacerts $JAVA_HOME/lib/security/cacerts.bakup-${backup_timestamp} && \
# Create a directory to hold the REWE digital certificates and copy them there
###mkdir -p $JAVA_HOME/lib/security/rewedigital_certs/ && \
###cp ~/mydata/auth_certificates_keys/rewedigital/java/cacerts/cacerts_rewedigital $JAVA_HOME/lib/security/rewedigital_certs/ && \
###cp ~/mydata/auth_certificates_keys/rewedigital/java/cacerts/RS_ROOTCA02.cer $JAVA_HOME/lib/security/rewedigital_certs/ && \
###cp ~/mydata/auth_certificates_keys/rewedigital/java/cacerts/RS\ hosted\ DeviceCA06.cer $JAVA_HOME/lib/security/rewedigital_certs/ && \
# Create a copy of the original cacerts file to import the REWE digital certificates into
###cp $JAVA_HOME/lib/security/cacerts $JAVA_HOME/lib/security/rewedigital_certs/ && \
# cd into the directory and import the REWE digital certificates into the copy of the original cacerts file
###cd $JAVA_HOME/lib/security/rewedigital_certs/ && \
###keytool -importcert -file RS_ROOTCA02.cer -alias "RS_ROOTCA02" -keystore cacerts -storepass changeit && \
###keytool -importcert -file RS\ hosted\ DeviceCA06.cer -alias "RS hosted DeviceCA06" -keystore cacerts -storepass changeit && \
# Replace the original cacerts file with the modified copy containing the REWE digital certificates
###cp $JAVA_HOME/lib/security/rewedigital_certs/cacerts $JAVA_HOME/lib/security/cacerts
