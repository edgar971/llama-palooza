#!/bin/bash

REPO_URL="git@github.com:huggingface/transformers.git"
VIRTUALENV_NAME="transformers"
PYTHON_VERSION="3.10"
REPO_DIR="repos/transformers"

if [ ! -d "$REPO_DIR" ]; then
    echo "Cloning repository..."
    git clone "$REPO_URL" "$REPO_DIR" || { echo "Failed to clone the repository. Exiting."; exit 1; }
fi

cd "$REPO_DIR"

eval "$(pyenv init -)"

echo "Creating pyenv virtualenv..."

if ! pyenv versions | grep -q $VIRTUALENV_NAME; then
    pyenv virtualenv $PYTHON_VERSION $VIRTUALENV_NAME || { echo "Failed to create virtualenv. Exiting."; exit 1; }
fi

pyenv activate $VIRTUALENV_NAME

pip install transformers datasets accelerate sentencepiece protobuf==3.20 py7zr scipy peft bitsandbytes fire torch_tb_profiler ipywidgets torch
 
echo "Setup completed successfully!"
