#!/bin/bash

# Converts a PyTorch model to GGML FP32 and quantizes it to GGML Q4.0

MODEL_PATH=$1
LLAMA_CPP_REPO="./repos/llama.cpp"
TOKENIZER_PATH="./models/tokenizer.model"
QUANTIZE_BIN="$LLAMA_CPP_REPO/quantize"

GGML_DEFAULT_NAME="ggml-model-f16.bin"

if [ -z "$MODEL_PATH" ]; then
  echo "Usage: $0 <model_path>"
  exit 1
fi

echo "Converting model $MODEL_PATH to GGML FP16"

eval "$(pyenv init -)"

pyenv activate llm

if [ ! -f "$MODEL_PATH/$GGML_DEFAULT_NAME" ]; then
  python $LLAMA_CPP_REPO/convert.py $MODEL_PATH --vocab-dir $TOKENIZER_PATH --outtype f16
else 
  echo "GGML FP32 model already exists"
fi

if [ ! -f "$MODEL_PATH/ggml-model-q4_0.bin" ]; then
  echo "Quantizing model $MODEL_PATH to GGML Q4.0"
  $QUANTIZE_BIN $MODEL_PATH/$GGML_DEFAULT_NAME $MODEL_PATH/ggml-model-q4_0.bin q4_0
else 
  echo "GGML Q4.0 model already exists"
fi
