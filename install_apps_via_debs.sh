#!/bin/bash

#
# Installs various applications via their .deb packages.
#

FOLDER=/tmp/debs001
mkdir -p ${FOLDER}

download_deb() {
    local DEB_URL=$1
    local DEB_NAME=$2
    wget ${DEB_URL} -O ${FOLDER}/${DEB_NAME}
}

install_deb() {
    local DEB_NAME=$1
    sudo apt install ${FOLDER}/${DEB_NAME}
}

# ---

download_deb 'https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb' 'google-chrome-stable_current_amd64.deb'
download_deb 'https://go.microsoft.com/fwlink/?LinkID=760868' 'vscode.deb'
download_deb 'https://packages.microsoft.com/repos/edge/pool/main/m/microsoft-edge-stable/microsoft-edge-stable_136.0.3240.64-1_amd64.deb' 'microsoft-edge-stable_amd64.deb'
download_deb 'https://kafkio.com/download/kafkio/2.0.9/KafkIO-linux-2.0.9-x64.deb' 'kafkio.deb'
download_deb 'https://www.keepersecurity.com/desktop_electron/Linux/repo/deb/keeperpasswordmanager_17.4.1_amd64.deb' 'keeperpasswordmanager.deb'

# ---

install_deb 'google-chrome-stable_current_amd64.deb'
install_deb 'vscode.deb'
install_deb 'microsoft-edge-stable_amd64.deb'
install_deb 'kafkio.deb'
install_deb 'keeperpasswordmanager.deb'

# ---

sudo apt update
