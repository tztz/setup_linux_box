#!/bin/bash

GROUP_FOLDER=aws
APP_FOLDER_NAME=aws-cli
DOWNLOAD_URI=https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip

MYAPPS_VENDOR_FOLDER=~/myapps/vendor
APP_ROOT_FOLDER=$MYAPPS_VENDOR_FOLDER/$GROUP_FOLDER

if [ -d "$APP_ROOT_FOLDER" ]; then
    echo "AWS CLI already exists. Skipping."
    echo "In order to update, delete folder $APP_ROOT_FOLDER and run this script again."
    exit 1
else
    mkdir -p $APP_ROOT_FOLDER && \
    cd $APP_ROOT_FOLDER && \
    rm -rf $APP_ROOT_FOLDER/$APP_FOLDER_NAME && \
    curl -s -L ${DOWNLOAD_URI} -o "awscliv2.zip" && \
    unzip -u awscliv2.zip && \
    $APP_ROOT_FOLDER/aws/install --install-dir $APP_ROOT_FOLDER/$APP_FOLDER_NAME --bin-dir ~/bin/common/aws-cli --update && \
    rm -rf awscliv2.zip
fi
