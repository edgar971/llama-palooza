#!/bin/bash

PYTHON_VERSION="3.10"  
ENV_NAME="llm" 
MODELS_PATH="./models"
REPOS_PATH="./repos"

### Check if pyenv is installed
if ! command -v pyenv &> /dev/null; then
    echo "pyenv is not installed. Please install pyenv first."
    exit 1
fi

### Create directories
mkdir -p $MODELS_PATH
mkdir -p $REPOS_PATH

###  Init pyenv to create, activate, and install packages in a virtual environment
eval "$(pyenv init -)"

if ! pyenv versions | grep -q $ENV_NAME; then
    pyenv virtualenv $PYTHON_VERSION $ENV_NAME
fi

pyenv activate $ENV_NAME

pip install --upgrade pip
pip install pytest cmake scikit-build setuptools fastapi uvicorn sse-starlette pydantic-settings torch

# Install this version compatible with CUDA 11.2
python -m pip install llama-cpp-python --prefer-binary --extra-index-url=https://jllllll.github.io/llama-cpp-python-cuBLAS-wheels/AVX2/cu122

### Get download.sh script from the llama repo

# file_url="https://raw.githubusercontent.com/facebookresearch/llama/main/download.sh"
# download_dir="./scripts"
# file_name="download-models.sh"

# # Check if the file already exists
# if [ -f "$download_dir/$file_name" ]; then
#     echo "File already exists. No need to download."
# else
#     # Create the download directory if it doesn't exist
#     mkdir -p "$download_dir"

#     # Download the file using curl
#     curl -o "$download_dir/$file_name" "$file_url"

#     # Check if the download was successful
#     if [ $? -eq 0 ]; then
#         echo "File downloaded successfully."
#     else
#         echo "Failed to download the file."
#         exit 1
#     fi
# fi


### Clone the llama repo and llama.cpp

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