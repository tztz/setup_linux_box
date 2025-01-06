#!/bin/bash

# Check whether `minikube` is installed
minikube_existent=$(command -v minikube)
if [ "${minikube_existent}" == "" ]; then
    echo "minikube does not exist. Skipping."
    exit 1
fi

# Check whether minikube is already running
minikube status > /dev/null
minikube_status=$?
if [ $minikube_status == 0 ]; then
    echo "minikube is already running. Skipping."
    exit 0
fi

# Start minikube (download if needed)
minikube start && \
minikube addons enable ingress && \
minikube addons enable ingress-dns && \
minikube status
