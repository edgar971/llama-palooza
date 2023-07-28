import torch 

from llama_cpp import Llama, LlamaCache, LogitsProcessorList


model_path = "/home/edgar-pino/dev/llama/text-generation-webui/models/TheBloke_Llama-2-7B-Chat-GGML/llama-2-7b-chat.ggmlv3.q4_0.bin"

llm = Llama(model_path, n_gpu_layers=128, n_ctx=1024)

output = llm(
    "Question: What are the names of the planets in the solar system? Answer: ",
    max_tokens=48,
    stop=["Q:", "\n"],
    echo=True,
)