import os
from uuid import uuid4
from transformers import LlamaForCausalLM, LlamaTokenizer, BitsAndBytesConfig
from itertools import chain
from transformers import (
    default_data_collator,
    Trainer,
    TrainingArguments,
    TrainerCallback,
)
from trl import SFTTrainer
import torch
import datasets
from peft import (
    get_peft_model,
    LoraConfig,
    TaskType,
    prepare_model_for_int8_training,
    AutoPeftModelForCausalLM,
)
import datetime

torch.cuda.empty_cache()

os.environ["PYTORCH_CUDA_ALLOC_CONF"] = "max_split_size_mb:1024"

model_id = "./models/7B-hf"

version_date = int(datetime.datetime.now().timestamp())

device_map = {"": 0}
output_dir = f"./llama-coder-7B-hf/{version_date}"
final_checkpoint_dir = os.path.join(output_dir, "final_checkpoint")


# load tokenizer
tokenizer = LlamaTokenizer.from_pretrained(model_id)
tokenizer.pad_token = tokenizer.eos_token


# load model
bnb_config = BitsAndBytesConfig(
    load_in_4bit=True,
    bnb_4bit_quant_type="nf4",
    bnb_4bit_compute_dtype=torch.float16,
)

base_model = LlamaForCausalLM.from_pretrained(
    model_id,
    quantization_config=bnb_config,
    device_map=device_map,
    torch_dtype=torch.float16,
)
base_model.config.use_cache = False
base_model.config.pretraining_tp = 1


def apply_prompt_template(samples, tokenizer):
    prompt = f"Implement the following program given the instructions:\n{{instructions}}\n---\nCode:\n{{code}}{{eos_token}}"

    batch_text = []

    batch = list(zip(samples["prompt"], samples["response"]))

    for sample in batch:
        text = prompt.format(
            instructions=sample[0],
            code=sample[1],
            eos_token=tokenizer.eos_token,
        )
        batch_text.append(text)

    return {"text": batch_text}


def get_preprocessed_codes(tokenizer, split):
    dataset = datasets.load_dataset("nampdn-ai/tiny-codes", split=split)
    dataset = dataset.shuffle().select(range(50_000))

    def apply_prompt_template_batch(samples):
        return apply_prompt_template(samples, tokenizer)

    return dataset.map(
        apply_prompt_template_batch,
        batched=True,
        remove_columns=list(dataset.features),
    )


# load dataset
dataset = get_preprocessed_codes(tokenizer, "train")


max_seq_length = 1024

# Define training args
training_args = TrainingArguments(
    output_dir=output_dir,
    overwrite_output_dir=True,
    fp16=True,  # Use fp16 if available
    logging_dir=f"{output_dir}/logs",
    logging_strategy="steps",
    logging_steps=50,
    save_strategy="no",
    optim="adamw_torch_fused",
    max_steps=1000,
    report_to="none",
    learning_rate=1e-4,
    num_train_epochs=1,
    dataloader_num_workers=os.cpu_count(),
    per_device_train_batch_size=4,
    gradient_accumulation_steps=2,
    per_device_eval_batch_size=4,
    gradient_checkpointing=False,
)

peft_config = LoraConfig(
    task_type=TaskType.CAUSAL_LM,
    inference_mode=False,
    r=8,
    lora_alpha=32,
    lora_dropout=0.05,
    target_modules=["q_proj", "v_proj"],
)

# https://huggingface.co/docs/trl/main/en/sft_trainer
trainer = SFTTrainer(
    model=base_model,
    train_dataset=dataset,
    peft_config=peft_config,
    dataset_text_field="text",
    max_seq_length=max_seq_length,
    tokenizer=tokenizer,
    args=training_args,
    callbacks=[],
)

# Start training
trainer.train()

trainer.model.save_pretrained(final_checkpoint_dir)
