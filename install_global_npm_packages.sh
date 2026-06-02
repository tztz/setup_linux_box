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

# Install packages from the list in pkglist_npm.txt (ignoring comments and blank lines)
grep -v '^\s*#' "$BASE_FOLDER/pkglist_npm.txt" | grep -v '^\s*$' | xargs -r npm install -g
