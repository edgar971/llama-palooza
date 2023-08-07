#!/bin/bash

REPO_URL="https://github.com/oobabooga/text-generation-webui"
VIRTUALENV_NAME="llm-ui"
PYTHON_VERSION="3.10"
REPO_DIR="repos/text-generation-webui"

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

pip install -r requirements.txt || { echo "Failed to install requirements. Exiting."; exit 1; }

echo "Setup completed successfully!"
