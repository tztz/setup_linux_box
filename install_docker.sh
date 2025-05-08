#!/bin/bash

mkdir -p /tmp/docker_install
curl -fsSL https://get.docker.com -o /tmp/docker_install/get-docker.sh && \
sudo sh /tmp/docker_install/get-docker.sh
