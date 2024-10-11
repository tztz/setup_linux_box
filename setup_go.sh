    #!/bin/bash

GOENV_FOLDER_NAME=$HOME/.goenv

# Install goenv
if [ -d "$GOENV_FOLDER_NAME" ]; then
    echo "goenv already exists. Skipping."
    echo "In order to update, delete folder $GOENV_FOLDER_NAME and run this script again."
else
    git clone https://github.com/go-nv/goenv.git $GOENV_FOLDER_NAME
fi

# Install latest Go version, make it globally available
go_version=latest
goenv install --skip-existing $go_version
goenv global $go_version
