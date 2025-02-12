#!/bin/bash

# Download and install SDKMAN!
curl -s "https://get.sdkman.io" | bash && \
# Install packages
bash -ic 'sdk install java' && \
bash -ic 'sdk install kotlin' && \
bash -ic 'sdk install groovy'
