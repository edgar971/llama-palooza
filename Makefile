
setup:
	bash ./scripts/setup-env.sh

build-llama-cpp:
	cd $(LLAMA_CPP_REPO) && make && python -m pip install -r requirements.txt

download_models:
	bash ./scripts/download-models.sh

process_model:
	bash ./scripts/convert-and-quantize.sh $(MODEL_NAME)