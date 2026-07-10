#!/bin/bash

#
# This script installs applications via the apt package manager.
# It also adds repositories for applications that are not in the
# default Ubuntu repositories.
#

if [[ "$BASE_FOLDER" == '' ]]; then
    BASE_FOLDER=~/mydata/projects/private/shell-tools/setup_linux_box
fi

# --- First, add the GPG keys

# Microsoft signing key
curl -fsSL https://packages.microsoft.com/keys/microsoft.asc | sudo gpg --batch --yes --dearmor -o /usr/share/keyrings/microsoft.gpg || { echo "ERROR: Failed to add Microsoft GPG key" >&2; exit 1; }

# Google signing key
curl -fsSL https://dl.google.com/linux/linux_signing_key.pub | sudo gpg --batch --yes --dearmor -o /usr/share/keyrings/google-chrome.gpg || { echo "ERROR: Failed to add Google GPG key" >&2; exit 1; }

# DBeaver signing key
curl -fsSL https://dbeaver.io/debs/dbeaver.gpg.key | sudo gpg --batch --yes --dearmor -o /usr/share/keyrings/dbeaver.gpg || { echo "ERROR: Failed to add DBeaver GPG key" >&2; exit 1; }

# --- Next, add the repository entries for the applications (with the correct
# --- signed-by option to reference the GPG keys added above)

# Visual Studio Code
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/microsoft.gpg] https://packages.microsoft.com/repos/vscode stable main" | sudo tee /etc/apt/sources.list.d/vscode.list > /dev/null

# Microsoft Edge
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/microsoft.gpg] https://packages.microsoft.com/repos/edge stable main" | sudo tee /etc/apt/sources.list.d/edge.list > /dev/null

# Google Chrome (stable)
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/google-chrome.gpg] https://dl.google.com/linux/chrome/deb stable main" | sudo tee /etc/apt/sources.list.d/google-chrome.list > /dev/null

# DBeaver
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/dbeaver.gpg] https://dbeaver.io/debs/dbeaver-ce /" | sudo tee /etc/apt/sources.list.d/dbeaver.list > /dev/null

# Refresh package lists so the newly added repositories are picked up
sudo apt update

# -------------

# Install applications from the list in pkglist_apt.txt (ignoring comments and blank lines)
grep -v '^\s*#' "$BASE_FOLDER/pkglist_apt.txt" | grep -v '^\s*$' | xargs -r sudo apt -y install
