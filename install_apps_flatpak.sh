#!/bin/bash

#
# This script installs flatpak applications.
#

if [[ "$BASE_FOLDER" == '' ]]; then
    BASE_FOLDER=~/mydata/projects/private/shell-tools/setup_linux_box
fi

flatpak -y install $(cat $BASE_FOLDER/pkglist_flatpak.txt)
