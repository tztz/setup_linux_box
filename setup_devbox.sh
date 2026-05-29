#!/bin/bash

devbox version &> /dev/null
devbox_exists=$?
if [ $devbox_exists -eq 0 ]; then
    echo "Devbox already exists. Skipping."
    exit 0
fi

curl -fsSL https://get.jetify.com/devbox | bash

bash -ic 'devbox'
