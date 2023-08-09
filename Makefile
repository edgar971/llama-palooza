
setup:
	bash ./scripts/setup-gpu.sh
	bash ./scripts/setup-env.sh

build-llama-cpp:
	cd $(LLAMA_CPP_REPO) && make && python -m pip install -r requirements.txt

download_models:
	bash ./scripts/download-models.sh

process_model:
	bash ./scripts/convert-and-quantize.sh $(MODEL_PATH)

ui:
	@eval "$$(pyenv init -)" && \
	cd ./repos/text-generation-webui && \
	pyenv activate llm-ui && \
	python server.py --model-dir ../../models


to_hf:
	@eval "$$(pyenv init -)" && \
	cd ./repos/transformers && \
	pyenv activate transformers && \
	python src/transformers/models/llama/convert_llama_weights_to_hf.py \
    --input_dir $(MODEL_PATH) --model_size $(MODEL_SIZE) --output_dir $(MODEL_OUTPUT_DIR)
