# LLama 2 Tools and FastAPI

A collection of scripts and a FastAPI server designed for Llama 2, utilizing both llama.cpp and Python bindings.

## Getting started

1. Clone repo. 
2. Run `make setup`. This will setup CUDA with Docker, create directories, and create a virtual python env. 

## Preparing Models

Before using Llama.cpp, we need to convert the models to GGML format. Additionally, to optimize memory usage and reduce overall model size, we will quantize the models to 4-bits. 

To prepare the models, follow these steps:

1. **Download LLama 2 models**: Obtain the required LLama 2 models by going [here](https://ai.meta.com/resources/models-and-libraries/llama-downloads/). 
2. Once you get the email, copy the link and run the following command: `make download_models`. Follow the promps and wait for the selected models to download. The default directory is `./models`.
3. **Convert to GGML FP16 format and 4-bit quantization**: This is to reduce memory footprint, lower model size, and improve inference times. This can be done by running the following script: `make process_model MODEL_NAME=models/llama-2-13b-chat`


## FastAPI Server

To begin using the FastAPI server for LLama 2, follow these steps:

1. **Set the `MODEL` Environment Variable**: Before starting the server, ensure that the `MODEL` environment variable is correctly set. This variable should point to the GGML version of the model you want to use. For instance: `export MODEL=./models/llama-2-7b-chat.ggmlv3.q4_0.bin`.

2. **Start the Server**: Launch the FastAPI server using the following command:

   ```
   python -m llama_cpp.server --n_gpu_layers=64
   ```

   (Additional server options and configurations can be found [here](https://github.com/abetlen/llama-cpp-python/blob/main/llama_cpp/server/app.py#L23).)

3. **Explore the API Documentation**: Once the server is up and running, you can access the interactive API documentation by navigating to `http://localhost:8000/docs` in your web browser. This documentation provides detailed information on available endpoints and how to interact with them.

## Finetuning Models

See `finetune.py` or `finetune.ipynb` for examples.
