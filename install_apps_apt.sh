#!/bin/bash

#
# This script installs apt applications.
#

if [[ "$BASE_FOLDER" == '' ]]; then
    BASE_FOLDER=~/mydata/projects/private/shell-tools/setup_linux_box
fi

xargs sudo apt -y install < $BASE_FOLDER/pkglist_apt.txt
