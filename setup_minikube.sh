#!/bin/bash

# Check whether `minikube` is installed
if ! command -v minikube &> /dev/null; then
    echo "minikube does not exist. Skipping."
    exit 0
fi

# Check whether minikube is already running
if minikube status &> /dev/null; then
    echo "minikube is already running. Skipping."
    exit 0
fi

# Start minikube (download if needed)
minikube start && \
minikube addons enable ingress && \
minikube addons enable ingress-dns && \
minikube status
