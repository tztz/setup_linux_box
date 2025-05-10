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

        echo "Installing flatpak packages ..."
        flatpak -y install $(cat $BASE_FOLDER/pkglist_flatpak.txt)
    else
        echo "apt update ..."
        sudo apt update

        echo "Installing via apt ..."
        xargs sudo apt -y install < $BASE_FOLDER/pkglist_apt.txt

        echo "Installing deb files ..."
        $BASE_FOLDER/install_apps_via_debs.sh

        echo "Installing Docker Desktop ..."
        $BASE_FOLDER/install_docker_desktop.sh

        echo "Installing snap packages ..."
        $BASE_FOLDER/install_snaps.sh
    fi
fi

if [[ "$OPERATING_SYSTEM" == 'Darwin' ]]; then
    # Install macOS apps ...

    echo "TODO: Install macOS apps"
fi
