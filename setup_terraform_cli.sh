#!/bin/bash

if ! command -v terraform &> /dev/null; then
    echo "terraform not found on PATH. Skipping autocomplete setup."
    echo "Make sure terraform is installed (e.g. via devbox global) and run this script again."
    exit 0
fi

# Enable tab completion (idempotent: skip if it was already installed)
output=$(terraform -install-autocomplete 2>&1)
exit_code=$?
if echo "$output" | grep -qi "already installed"; then
    echo "Terraform autocomplete already installed. Skipping."
elif [[ $exit_code -ne 0 ]]; then
    echo "Warning: terraform -install-autocomplete failed: $output" >&2
else
    echo "Terraform autocomplete installed."
fi
