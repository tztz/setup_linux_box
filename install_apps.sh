#!/bin/bash

if [[ "$BASE_FOLDER" == '' ]]; then
    BASE_FOLDER=~/mydata/projects/private/shell-tools/setup_linux_box
fi

OPERATING_SYSTEM=$(uname -o)

if [[ "$OPERATING_SYSTEM" == 'GNU/Linux' ]]; then
    # Install Linux apps ...

    # Install classic packages
    yay -S --needed --noconfirm - < $BASE_FOLDER/pkglist_yay.txt
    #xargs sudo apt-get -y install < pkglist_aptget.txt

    # Install flatpak packages
    flatpak -y install $(cat $BASE_FOLDER/pkglist_flatpak.txt)
fi

if [[ "$OPERATING_SYSTEM" == 'Darwin' ]]; then
    # Install macOS apps ...

    echo "TODO: Install macOS apps"
fi
