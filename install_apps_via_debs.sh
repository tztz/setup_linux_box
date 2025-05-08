#!/bin/bash

mkdir -p /tmp/debs001

wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb -O /tmp/debs001/google-chrome-stable_current_amd64.deb
wget https://www.synaptics.com/sites/default/files/Ubuntu/pool/stable/main/all/synaptics-repository-keyring.deb -O /tmp/debs001/synaptics-repository-keyring.deb
wget https://vscode.download.prss.microsoft.com/dbazure/download/stable/17baf841131aa23349f217ca7c570c76ee87b957/code_1.99.3-1744761595_amd64.deb -O /tmp/debs001/vscode.deb

sudo apt install /tmp/debs001/google-chrome-stable_current_amd64.deb
sudo apt install /tmp/debs001/synaptics-repository-keyring.deb
sudo apt install /tmp/debs001/vscode.deb

sudo apt update

sudo apt install google-chrome-stable
sudo apt install displaylink-driver
sudo apt install code
