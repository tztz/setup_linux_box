#!/bin/bash

BASE_FOLDER=~/mydata/projects/private/shell-tools/setup_linux_box

TEXT_COLOR_LIGHTRED='\033[1;31m'
TEXT_COLOR_ORANGE='\033[0;33m'
TEXT_COLOR_GREEN='\033[0;32m'
TEXT_COLOR_LIGHTBLUE='\033[0;34m'
TEXT_COLOR_OFF='\033[0m'

function print_headline() {
    echo -e "${TEXT_COLOR_LIGHTBLUE}"
    echo ""
    echo ""
    echo "#########################################################################"
    echo "#  $1"
    echo "#########################################################################"
    echo -e "${TEXT_COLOR_OFF}"
}

function print_todo() {
    echo ""
    echo -e "${TEXT_COLOR_ORANGE}>>> TODO for ${USER}: $1${TEXT_COLOR_OFF}"
}

function print_ok() {
    echo "OK."
}

####################################################################################
# Prerequisites
####################################################################################

print_headline "Check prerequisites"

[ -d "~/mydata" ] && \
echo -e "${TEXT_COLOR_LIGHTRED}~/mydata has not yet been restored from backup, this must be done first." && \
echo "" && \
echo "Giving up." && \
echo -e "${TEXT_COLOR_OFF}" && \
exit 1

[ ! -d "~/mydata" ] && \
print_ok

###################################################################################
# Software installation
####################################################################################

print_headline "Install packages"

BASE_FOLDER=$BASE_FOLDER $BASE_FOLDER/install_apps.sh

####################################################################################
# mise (mise-en-place)
# https://github.com/jdx/mise/
# https://mise.jdx.dev/
####################################################################################

print_headline "Install mise"

$BASE_FOLDER/setup_mise.sh

####################################################################################
# Install dev tools via mise
# https://github.com/jdx/mise/
# https://mise.jdx.dev/
####################################################################################

print_headline "Install dev tools via mise"

$BASE_FOLDER/setup_dev_env_via_mise.sh

####################################################################################
# Global npm packages
####################################################################################

###print_headline "Install global npm packages"

###$BASE_FOLDER/install_global_npm_packages.sh

####################################################################################
# Docker
####################################################################################

print_headline "Start and setup docker service, add user '$USER' to group 'docker'"

$BASE_FOLDER/setup_docker.sh && \
print_ok

####################################################################################
# OpenVPN
# https://openvpn.net/
####################################################################################

print_headline "Setup VPNs"

$BASE_FOLDER/setup_vpn.sh && \
print_todo "Open the VPN config UI and enter your credentials (username, password)" && \
print_todo "Check that the checkboxes 'Use this connection only for resources on its network' are ticked for IPv4 and IPv6"

####################################################################################
# Google Cloud CLI (gcloud)
# https://cloud.google.com/sdk/docs/install
####################################################################################

print_headline "Download, install, and setup Google Cloud CLI (gcloud), install components"

$BASE_FOLDER/setup_gcloud_cli.sh

####################################################################################
# AWS CLI (aws)
# https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html
####################################################################################

print_headline "Download, install, and setup AWS CLI (aws)"

$BASE_FOLDER/setup_aws_cli.sh

####################################################################################
# Terraform CLI
# https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli
####################################################################################

print_headline "Setup Terraform CLI"

$BASE_FOLDER/setup_terraform_cli.sh

####################################################################################
# Minikube
# https://minikube.sigs.k8s.io
####################################################################################

print_headline "Setup minikube"

$BASE_FOLDER/setup_minikube.sh

####################################################################################
# Symlinks
####################################################################################

print_headline "Create symlinks"

$BASE_FOLDER/setup_symlinks.sh

####################################################################################
# Directory permissions
####################################################################################

print_headline "Check/Fix directory permissions"

$BASE_FOLDER/fix_directory_permissions.sh && \
print_ok

####################################################################################
# Result
####################################################################################

print_headline "End of setup"

echo "Done."
echo ""
