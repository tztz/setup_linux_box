#!/bin/bash

if [[ "$BASE_FOLDER" == '' ]]; then
    BASE_FOLDER=~/mydata/projects/private/shell-tools/setup_linux_box
fi

# Install npm packages globally
npm install -g $(cat $BASE_FOLDER/pkglist_npm.txt)
