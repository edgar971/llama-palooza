#!/bin/bash

# Install CUDA if it's not already installed
if dpkg -l | grep -q "cuda"; then
    echo "CUDA is already installed on this system."
else
    wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2204/x86_64/cuda-keyring_1.1-1_all.deb

    if [ $? -eq 0 ]; then
        echo "CUDA keyring package downloaded successfully."
    else
        echo "Failed to download CUDA keyring package. Exiting."
        exit 1
    fi

    sudo dpkg -i cuda-keyring_1.1-1_all.deb

    sudo apt-get update

    sudo apt-get -y install cuda

    if [ $? -eq 0 ]; then
        echo "CUDA drivers installed successfully."
    else
        echo "Failed to install CUDA drivers. Please check the error messages above."
    fi
fi

# Install nvidia-container-toolkit if it's not already installed
if ! command -v nvidia-ctk &> /dev/null; then
    # Install Docker support for CUDA
    distribution=$(. /etc/os-release;echo $ID$VERSION_ID) \
          && curl -fsSL https://nvidia.github.io/libnvidia-container/gpgkey | sudo gpg --dearmor -o /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg \
          && curl -s -L https://nvidia.github.io/libnvidia-container/$distribution/libnvidia-container.list | \
                sed 's#deb https://#deb [signed-by=/usr/share/keyrings/nvidia-container-toolkit-keyring.gpg] https://#g' | \
                sudo tee /etc/apt/sources.list.d/nvidia-container-toolkit.list

    sudo apt-get update

    sudo apt-get install -y nvidia-container-toolkit

    sudo nvidia-ctk runtime configure --runtime=docker

    sudo systemctl restart docker

    echo "nvidia-container-toolkit installed and configured."
else
    echo "nvidia-container-toolkit is already installed."
fi

# Verify CUDA Docker support
docker run --rm --runtime=nvidia --gpus all nvidia/cuda:11.6.2-base-ubuntu20.04 nvidia-smi

echo "CUDA Docker support verified."
