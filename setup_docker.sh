#!/bin/bash

# Note: This is not needed (in fact, it will fail) if Docker Desktop is used!
# It's useful only if you have installed the Docker engine.

# Start docker service, enable auto-start
sudo systemctl start docker.service && sudo systemctl enable docker.service && \
# Add yourself ($USER) to `docker` group in order to run docker as normal user
sudo usermod -aG docker "${USER}"
