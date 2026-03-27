#!/bin/bash

#
# This script installs applications via the yay package manager.
#

if [[ "$BASE_FOLDER" == '' ]]; then
    BASE_FOLDER=~/mydata/projects/private/shell-tools/setup_linux_box
fi

yay -S --needed --noconfirm - < $BASE_FOLDER/pkglist_yay.txt
