# LLama 2 Tools and Web Server

A collection of scripts and a FastAPI server designed for Llama 2, utilizing both llama.cpp and Python bindings.

## Preparing Models

Before using Llama.cpp, we need to convert the models to GGML format. Additionally, to optimize memory usage and reduce overall model size, we will quantize the models to 4-bits. 

To prepare the models, follow these steps:

1. **Download LLama 2 models**: Obtain the required LLama 2 models.
2. **Convert to FP32**
2. **Quantization**: Perform 4-bit quantization on the downloaded models to reduce memory footprint and improve efficiency.


## Starting the FastAPI Server

To begin using the FastAPI server for LLama 2, follow these steps:

1. **Set the `MODEL` Environment Variable**: Before starting the server, ensure that the `MODEL` environment variable is correctly set. This variable should point to the GGML version of the model you want to use. For instance: `export MODEL=./models/llama-2-7b-chat.ggmlv3.q4_0.bin`.

2. **Start the Server**: Launch the FastAPI server using the following command:

   ```
   python3 -m llama_cpp.server --n_gpu_layers=64
   ```

   (Additional server options and configurations can be found [here](https://github.com/abetlen/llama-cpp-python/blob/main/llama_cpp/server/app.py#L23).)

3. **Explore the API Documentation**: Once the server is up and running, you can access the interactive API documentation by navigating to `http://localhost:8000/docs` in your web browser. This documentation provides detailed information on available endpoints and how to interact with them.
