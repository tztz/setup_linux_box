#!/bin/bash

mise --version &> /dev/null
mise_exists=$?
if [ $mise_exists -eq 0 ]; then
    echo "mise already exists. Skipping."
    exit 0
fi

curl https://mise.run | sh
echo 'eval "$(~/.local/bin/mise activate bash)"' >> ~/.bashrc
eval "$(~/.local/bin/mise activate bash)"
mise doctor
