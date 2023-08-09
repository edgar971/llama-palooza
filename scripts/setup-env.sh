#!/bin/bash

PYTHON_VERSION="3.10"  
ENV_NAME="llm" 
MODELS_PATH="./models"
REPOS_PATH="./repos"

if ! command -v pyenv &> /dev/null; then
    echo "pyenv is not installed. Please install pyenv first."
    exit 1
fi

if ! command -v docker &> /dev/null; then
    echo "Docker is not installed. Please install Docker first."
    exit 1
fi

mkdir -p $MODELS_PATH
mkdir -p $REPOS_PATH

###  Init pyenv to create, activate, and install packages in a virtual environment
eval "$(pyenv init -)"

if ! pyenv versions | grep -q $ENV_NAME; then
    pyenv virtualenv $PYTHON_VERSION $ENV_NAME
fi

pyenv activate $ENV_NAME

pip install --upgrade pip
pip install -r requirements.txt

# Install this version compatible with CUDA 11.2
python -m pip install llama-cpp-python --prefer-binary --extra-index-url=https://jllllll.github.io/llama-cpp-python-cuBLAS-wheels/AVX2/cu122

### Clone the llama.cpp
repo_url="https://github.com/ggerganov/llama.cpp.git"  
clone_dir="$REPOS_PATH/llama.cpp"

if [ -d "$clone_dir" ]; then
    echo "Repository already exists. No need to clone."
else
    git clone "$repo_url" "$clone_dir"

    if [ $? -eq 0 ]; then
        echo "Repository cloned successfully."
    else
        echo "Failed to clone the repository."
        exit 1
    fi
fi