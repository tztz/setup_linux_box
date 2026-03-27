#!/bin/bash

#
# This script installs applications via npm.
#
# The npm packages are installed globally, so they are available system-wide.
#

if [[ "$BASE_FOLDER" == '' ]]; then
    BASE_FOLDER=~/mydata/projects/private/shell-tools/setup_linux_box
fi

# ---

npm install -g $(cat $BASE_FOLDER/pkglist_npm.txt)
