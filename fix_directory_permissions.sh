#!/bin/bash

# Remove all "group" and "other" access from these files and directories.
# Each path is handled independently so a missing one does not abort the rest.

paths=(
    ~/mydata/.cert
    ~/mydata/.ssh/keys
    ~/mydata/.gnupg/my_asc_priv_keys
    ~/mydata/.gnupg/openpgp-revocs.d
    ~/mydata/.gnupg/private-keys-v1.d
    ~/mydata/auth_certificates_keys
    ~/mydata/app_data
)

for path in "${paths[@]}"; do
    if [[ -e "$path" ]]; then
        echo "Fixing permissions for     $path"
        chmod -R go-rwx "$path"
    else
        echo "Skipping (does not exist)  $path"
    fi
done
