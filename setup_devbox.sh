#!/bin/bash

if command -v devbox &> /dev/null; then
    echo "Devbox already exists. Skipping."
    exit 0
fi

curl -fsSL https://get.jetify.com/devbox | bash

bash -ic 'devbox'
