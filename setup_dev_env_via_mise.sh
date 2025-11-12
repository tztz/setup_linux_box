#!/bin/bash

mise self-update
mise ugrade
mise doctor

# Packages to install:
mise use --global node@latest
mise use --global go@latest
mise use --global terraform@latest
mise use --global kubectl@latest
mise use --global kubectx@latest
mise use --global minikube@latest
mise use --global k9s@latest
mise use --global helm@latest
mise use --global rancher@latest
mise use --global kafkactl
