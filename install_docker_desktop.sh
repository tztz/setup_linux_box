#!/bin/bash

#
# Docker Desktop is an alternative to the Docker engine.
# If you choose to install Docker Desktop you do not need the Docker engine.
#
# Prefer to install the Docker engine (see the install_docker_engine.sh file).
# Do not install both.
#

# Note: You do not need to log in into the Docker Desktop!
wget 'https://desktop.docker.com/linux/main/amd64/docker-desktop-amd64.deb' -O /tmp/debs001/docker-desktop-amd64.deb && \
sudo apt install /tmp/debs001/docker-desktop-amd64.deb
