#!/bin/bash

mkdir -p /tmp/debs001

wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb -O /tmp/debs001/google-chrome-stable_current_amd64.deb
wget https://www.synaptics.com/sites/default/files/Ubuntu/pool/stable/main/all/synaptics-repository-keyring.deb -O /tmp/debs001/synaptics-repository-keyring.deb
wget https://go.microsoft.com/fwlink/?LinkID=760868 -O /tmp/debs001/vscode.deb

sudo apt install /tmp/debs001/google-chrome-stable_current_amd64.deb
sudo apt install /tmp/debs001/synaptics-repository-keyring.deb
sudo apt install /tmp/debs001/vscode.deb

sudo apt update

sudo apt install google-chrome-stable
sudo apt install displaylink-driver
sudo apt install code
