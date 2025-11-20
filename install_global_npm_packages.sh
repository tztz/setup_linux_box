#!/bin/bash

#
# Installs various global npm packages.
#

if [[ "$BASE_FOLDER" == '' ]]; then
    BASE_FOLDER=~/mydata/projects/private/shell-tools/setup_linux_box
fi

# ---

npm install -g $(cat $BASE_FOLDER/pkglist_npm.txt)
