#!/bin/bash

mise --version &> /dev/null
mise_exists=$?
if [ $mise_exists -eq 0 ]; then
    echo "mise already exists. Skipping."
    exit 0
fi

curl https://mise.run | sh

line_to_add='eval "$(~/.local/bin/mise activate bash)"'
target_file=~/.bashrc
if grep -q "^$line_to_add$" "$target_file" ; then
    echo "'eval' line in $target_file already added. Skipping."
else
    echo "${line_to_add}" >> "${target_file}"
fi

bash -ic 'mise doctor'
