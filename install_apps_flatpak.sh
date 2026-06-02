#!/bin/bash

#
# This script installs applications via the flatpak package manager.
#

if [[ "$BASE_FOLDER" == '' ]]; then
    BASE_FOLDER=~/mydata/projects/private/shell-tools/setup_linux_box
fi

# Make sure the Flathub remote is available
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

# Install applications from the list in pkglist_flatpak.txt (ignoring comments and blank lines)
grep -v '^\s*#' "$BASE_FOLDER/pkglist_flatpak.txt" | grep -v '^\s*$' | xargs -r flatpak -y install
