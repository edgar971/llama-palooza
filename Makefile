
LLAMA_CPP_REPO := repos/llama.cpp


setup:
	bash ./scripts/setup-env.sh

build-llama-cpp:
	cd $(LLAMA_CPP_REPO) && make && python -m pip install -r requirements.txt

download_models:
	bash ./scripts/download-models.sh

process_model:
	python $(LLAMA_CPP_REPO)/convert.py ./models/llama-2-13b-chat --vocab-dir ./models/tokenizer.model
	$(LLAMA_CPP_REPO)/quantize ./models/llama-2-13b-chat/ggml-model-f32.bin ./models/llama-2-13b-chat/ggml-model-q4_0.bin q4_0

	