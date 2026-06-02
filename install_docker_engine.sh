#!/bin/bash

#
# This script installs the Docker engine.
#
# Alternatively, you could choose to install Docker Desktop instead (see the
# install_docker_desktop.sh file).
#
# Prefer to install the Docker engine.
# Do not install both!
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

# Install the Docker packages
sudo apt install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Start and setup docker service
echo "Start and setup docker service, add user '$USER' to group 'docker'"
$BASE_FOLDER/setup_docker.sh

# Verify the installation by running the hello-world image as the non-root user.
# The freshly added 'docker' group membership is not active in this shell yet, so
# use `sg` to run the test in a process that has the group activated (no sudo,
# no re-login needed).
if sg docker -c 'docker run --rm hello-world'; then
    echo "Docker verified successfully (non-root)."
else
    echo "Could not verify Docker as non-root in this session."
    echo "Log out and back in, then try: docker run --rm hello-world"
fi
