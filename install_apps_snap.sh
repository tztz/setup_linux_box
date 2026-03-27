#!/bin/bash

#
# This script installs applications via the snap package manager.
#

if [[ "$BASE_FOLDER" == '' ]]; then
    BASE_FOLDER=~/mydata/projects/private/shell-tools/setup_linux_box
fi

xargs -a $BASE_FOLDER/pkglist_snap.txt -L 1 sudo snap install

sudo snap refresh
