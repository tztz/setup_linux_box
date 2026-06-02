#!/bin/bash

#
# This script installs applications via the yay package manager.
#

if [[ "$BASE_FOLDER" == '' ]]; then
    BASE_FOLDER=~/mydata/projects/private/shell-tools/setup_linux_box
fi

# Install applications from the list in pkglist_yay.txt (ignoring comments and blank lines)
grep -v '^\s*#' "$BASE_FOLDER/pkglist_yay.txt" | grep -v '^\s*$' | yay -S --needed --noconfirm -
