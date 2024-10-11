#!/bin/bash

GROUP_FOLDER=gcloud
APP_FOLDER_NAME=google-cloud-sdk
DOWNLOAD_URI=https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-cli-477.0.0-linux-x86_64.tar.gz

MYAPPS_VENDOR_FOLDER=~/myapps/vendor
APP_ROOT_FOLDER=$MYAPPS_VENDOR_FOLDER/$GROUP_FOLDER

if [ -d "$APP_ROOT_FOLDER" ]; then
    echo "Google Cloud CLI already exists. Skipping."
    echo "In order to update, delete folder $APP_ROOT_FOLDER and run this script again."
    exit 1
else
    mkdir -p $APP_ROOT_FOLDER && \
    cd $APP_ROOT_FOLDER && \
    rm -rf $APP_ROOT_FOLDER/$APP_FOLDER_NAME && \
    curl -s -L ${DOWNLOAD_URI} | tar -xzv && \
    $APP_ROOT_FOLDER/$APP_FOLDER_NAME/install.sh -q --path-update True --command-completion True && \

    # Update all components
    $APP_ROOT_FOLDER/$APP_FOLDER_NAME/bin/gcloud -q components update && \

    #
    # Install components
    #

    # Do not install kubectl here! It's installed during execution of install_apps.sh
    #$APP_ROOT_FOLDER/$APP_FOLDER_NAME/bin/gcloud -q components install kubectl && \

    # Install gke-gcloud-auth-plugin
    $APP_ROOT_FOLDER/$APP_FOLDER_NAME/bin/gcloud -q components install gke-gcloud-auth-plugin

    # Install cloud-sql-proxy
    $APP_ROOT_FOLDER/$APP_FOLDER_NAME/bin/gcloud -q components install cloud-sql-proxy
fi
