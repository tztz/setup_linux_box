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
    echo -e "${TEXT_COLOR_GREEN}OK.${TEXT_COLOR_OFF}"
}

function print_fail() {
    local message="$1"
    echo -e "${TEXT_COLOR_LIGHTRED}FAILED.${TEXT_COLOR_OFF}"
    [ -n "$message" ] && echo -e "${TEXT_COLOR_LIGHTRED}$message${TEXT_COLOR_OFF}"
}

####################################################################################
# Prerequisites
####################################################################################

print_headline "Check prerequisites"

[ ! -d ~/mydata ] && \
print_fail "~/mydata has not yet been restored from backup, this must be done first. Giving up." && \
exit 1 || print_ok

###################################################################################
# File download
####################################################################################

print_headline "Download files"

$BASE_FOLDER/download_files.sh && \
print_ok || print_fail

###################################################################################
# Software installation
####################################################################################

print_headline "Install packages/apps"

BASE_FOLDER=$BASE_FOLDER $BASE_FOLDER/install_apps.sh && \
print_ok || print_fail

####################################################################################
# SDKMAN!
# https://sdkman.io/
####################################################################################

print_headline "Download and install SDKMAN!, install packages"

$BASE_FOLDER/setup_sdkman.sh && \
print_ok || print_fail

####################################################################################
# Java TrustStore (cacerts)
####################################################################################

print_headline "Copy Java TrustStore(s) in place"

$BASE_FOLDER/setup_java_truststore.sh && \
print_ok || print_fail

####################################################################################
# Devbox
# https://github.com/jetify-com/devbox
# https://www.jetify.com/devbox
####################################################################################

print_headline "Install Devbox"

$BASE_FOLDER/setup_devbox.sh && \
print_ok || print_fail

####################################################################################
# Install nix packages via Devbox
####################################################################################

print_headline "Install nix packages via Devbox"

$BASE_FOLDER/install_apps_devbox.sh && \
print_ok || print_fail

####################################################################################
# Global npm packages
####################################################################################

###print_headline "Install global npm packages"
###
###$BASE_FOLDER/install_global_npm_packages.sh

####################################################################################
# OpenVPN
# https://openvpn.net/
####################################################################################

print_headline "Setup VPNs"

$BASE_FOLDER/setup_vpn.sh && \
print_todo "Open the VPN config UI and enter your credentials (username, password)" && \
print_todo "Check that the checkboxes 'Use this connection only for resources on its network' are ticked for IPv4 and IPv6" || \
print_fail

####################################################################################
# Google Cloud CLI (gcloud)
# https://cloud.google.com/sdk/docs/install
####################################################################################

print_headline "Download, install, and setup Google Cloud CLI (gcloud), install components"

$BASE_FOLDER/setup_gcloud_cli.sh && \
print_ok || print_fail

####################################################################################
# AWS CLI (aws)
# https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html
####################################################################################

###print_headline "Download, install, and setup AWS CLI (aws)"

###$BASE_FOLDER/setup_aws_cli.sh

####################################################################################
# Terraform CLI
# https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli
####################################################################################

print_headline "Setup Terraform CLI"

$BASE_FOLDER/setup_terraform_cli.sh && \
print_ok || print_fail

####################################################################################
# IntelliJ IDEA desktop entry
# https://www.jetbrains.com/idea/download/
####################################################################################

print_headline "Setup IntelliJ IDEA desktop entry"

$BASE_FOLDER/setup_idea_desktop_entry.sh && \
print_ok || print_fail

####################################################################################
# Minikube
# https://minikube.sigs.k8s.io
####################################################################################

###print_headline "Setup minikube"
###
###$BASE_FOLDER/setup_minikube.sh

####################################################################################
# Symlinks
####################################################################################

print_headline "Create symlinks"

$BASE_FOLDER/setup_symlinks.sh && \
print_ok || print_fail

####################################################################################
# Directory permissions
####################################################################################

print_headline "Check/Fix directory permissions"

$BASE_FOLDER/fix_directory_permissions.sh && \
print_ok || print_fail

####################################################################################
# Result
####################################################################################

print_headline "End of setup. Close terminal now."

echo "Done."
echo ""
