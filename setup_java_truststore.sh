#!/bin/bash

#
# Replaces the Java TrustStore with the version from REWE digital's JFrog artifactory.
#
# TODO: It would be better to merge REWE's TrustStore into the original one instead of replacing it.
#

backup_timestamp=$(date +%Y-%m-%d_%H-%M-%S)

cp $JAVA_HOME/lib/security/cacerts $JAVA_HOME/lib/security/cacerts.bakup-${backup_timestamp} && \
cp ~/mydata/auth_certificates_keys/rewedigital/java/cacerts/cacerts_rewedigital $JAVA_HOME/lib/security/ && \
cp $JAVA_HOME/lib/security/cacerts_rewedigital $JAVA_HOME/lib/security/cacerts
