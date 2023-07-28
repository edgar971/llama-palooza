import torch 
import json
from llama_cpp import Llama, LlamaCache, LogitsProcessorList

model_path = "./models/llama-2-13b-chat/ggml-model-q4_0.bin"

llm = Llama(model_path, n_gpu_layers=128, n_ctx=1024, embedding=True)

stream = llm(
    "Question: Explain in detail Big O notation to a 5 year old? Answer: ",
    max_tokens=256,
    stop=["Q:", "\n"],
)

print(json.dumps(stream, indent=2))