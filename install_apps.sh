#!/bin/bash

if [[ "$BASE_FOLDER" == '' ]]; then
    BASE_FOLDER=~/mydata/projects/private/shell-tools/setup_linux_box
fi

OPERATING_SYSTEM=$(uname -o)
LINUX_DISTRIBUTION=$(cat /etc/os-release | sed -nE 's/^NAME="(.*)"$/\1/p')

if [[ "${OPERATING_SYSTEM}" == 'GNU/Linux' ]]; then
    # Install Linux apps ...

    # Install classic packages
    if [[ "${LINUX_DISTRIBUTION}" == 'EndeavourOS' || "${LINUX_DISTRIBUTION}" == 'Arch Linux' ]]; then
        echo "Installing via yay ..."
        yay -S --needed --noconfirm - < $BASE_FOLDER/pkglist_yay.txt
    else
        echo "Installing via apt-get ..."
        xargs sudo apt-get -y install < pkglist_apt.txt
    fi

    # Install flatpak packages
    ###flatpak -y install $(cat $BASE_FOLDER/pkglist_flatpak.txt)
fi

if [[ "$OPERATING_SYSTEM" == 'Darwin' ]]; then
    # Install macOS apps ...

    echo "TODO: Install macOS apps"
fi
