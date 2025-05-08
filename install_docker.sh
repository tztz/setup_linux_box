#!/bin/bash

# Check whether docker is already installed
if command -v docker 2>&1 >/dev/null; then
    echo "docker is already installed. Skipping."
    exit 0
fi

mkdir -p /tmp/docker_install
curl -fsSL https://get.docker.com -o /tmp/docker_install/get-docker.sh && \
sudo sh /tmp/docker_install/get-docker.sh
