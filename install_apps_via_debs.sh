#!/bin/bash

mkdir -p /tmp/debs001

# ---
wget 'https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb' -O /tmp/debs001/google-chrome-stable_current_amd64.deb
wget 'https://go.microsoft.com/fwlink/?LinkID=760868' -O /tmp/debs001/vscode.deb
wget 'https://packages.microsoft.com/repos/edge/pool/main/m/microsoft-edge-stable/microsoft-edge-stable_136.0.3240.64-1_amd64.deb' -O /tmp/debs001/microsoft-edge-stable_amd64.deb
wget 'https://kafkio.com/download/kafkio/2.0.9/KafkIO-linux-2.0.9-x64.deb' -O /tmp/debs001/kafkio.deb

# ---
sudo apt install /tmp/debs001/google-chrome-stable_current_amd64.deb
sudo apt install /tmp/debs001/vscode.deb
sudo apt install /tmp/debs001/microsoft-edge-stable_amd64.deb
sudo apt install /tmp/debs001/kafkio.deb

# ---
sudo apt update
