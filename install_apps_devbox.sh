#!/bin/bash

#
# This script installs applications globally via devbox.
#

if [[ "$BASE_FOLDER" == '' ]]; then
    BASE_FOLDER=~/mydata/projects/private/shell-tools/setup_linux_box
fi

# Install applications from the list in pkglist_devbox.txt
grep -v '^\s*#' "$BASE_FOLDER/pkglist_devbox.txt" | grep -v '^\s*$' | xargs -r devbox global add

# -------------

eval "$(devbox global shellenv)"
