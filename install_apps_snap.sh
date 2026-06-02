#!/bin/bash

#
# This script installs applications via the snap package manager.
#

if [[ "$BASE_FOLDER" == '' ]]; then
    BASE_FOLDER=~/mydata/projects/private/shell-tools/setup_linux_box
fi

# Install applications from the list in pkglist_snap.txt (ignoring comments and blank lines)
grep -v '^\s*#' "$BASE_FOLDER/pkglist_snap.txt" | grep -v '^\s*$' | xargs -r -L 1 sudo snap install

sudo snap refresh
