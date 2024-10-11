#!/bin/bash

# Remove all "group" and "other" access from these files and directories:
chmod -R go-rwx ~/mydata/.cert && \
chmod -R go-rwx ~/mydata/.ssh/keys && \
chmod -R go-rwx ~/mydata/.gnupg/my_asc_priv_keys && \
chmod -R go-rwx ~/mydata/.gnupg/openpgp-revocs.d && \
chmod -R go-rwx ~/mydata/.gnupg/private-keys-v1.d && \
chmod -R go-rwx ~/mydata/auth_certificates_keys && \
chmod -R go-rwx ~/mydata/app_data
