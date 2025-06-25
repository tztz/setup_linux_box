#!/bin/bash

#
# This script installs the Docker engine.
#
# Alternatively, you could choose to install Docker Desktop instead (see the
# install_docker_desktop.sh file).
#
# Prefer to install the Docker engine.
# Do not install both.
#

if [[ "$BASE_FOLDER" == '' ]]; then
    BASE_FOLDER=~/mydata/projects/private/shell-tools/setup_linux_box
fi

# Add Docker's official GPG key
sudo apt update
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt update

#Install the Docker packages
sudo apt install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Start and setup docker service
echo "Start and setup docker service, add user '$USER' to group 'docker'"
$BASE_FOLDER/setup_docker.sh

# Verify that the installation is successful by running the hello-world image as non-root user
docker run hello-world
