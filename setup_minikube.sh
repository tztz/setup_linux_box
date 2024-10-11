#!/bin/bash

# Check whether `minikube` is installed
minikube_existent=$(command -v minikube)
if [ "${minikube_existent}" == "" ]; then
    echo "minikube does not exist. Skipping."
    exit 1
fi

STATUS=$(minikube status -f {{.Host}})
if [ $STATUS != "Stopped" ]; then
    echo "minikube is already running. Skipping."
    exit 1
fi

# Start minikube (download if needed)
[ $(minikube status -f {{.Host}}) == "Stopped" ] && \
minikube start && \
minikube addons enable ingress && \
minikube addons enable ingress-dns
