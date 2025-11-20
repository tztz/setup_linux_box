#!/bin/bash

#
# Installs applications.
#

if [[ "$BASE_FOLDER" == '' ]]; then
    BASE_FOLDER=~/mydata/projects/private/shell-tools/setup_linux_box
fi

OPERATING_SYSTEM=$(uname -o)
LINUX_DISTRIBUTION=$(cat /etc/os-release | sed -nE 's/^NAME="(.*)"$/\1/p')

if [[ "${OPERATING_SYSTEM}" == 'GNU/Linux' ]]; then
    # Install Linux apps ...

    if [[ "${LINUX_DISTRIBUTION}" == 'EndeavourOS' || "${LINUX_DISTRIBUTION}" == 'Arch Linux' ]]; then
        echo ">>>>  Installing via yay ..."
        $BASE_FOLDER/install_apps_yay.sh

        echo ">>>>  Installing flatpak applications ..."
        $BASE_FOLDER/install_apps_flatpak.sh
    else
        echo ">>>>  apt update ..."
        sudo apt update

        echo ">>>>  Installing via apt ..."
        $BASE_FOLDER/install_apps_apt.sh

        echo ">>>>  Installing deb files ..."
        $BASE_FOLDER/install_apps_deb.sh

        echo ">>>>  Installing the Docker engine ..."
        $BASE_FOLDER/install_docker_engine.sh

        echo ">>>>  Installing snap applications ..."
        $BASE_FOLDER/install_apps_snap.sh
    fi
fi

if [[ "$OPERATING_SYSTEM" == 'Darwin' ]]; then
    # Install macOS apps ...

    echo "TODO: Install macOS apps"
fi
