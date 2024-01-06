#!/bin/bash

# Uncomment and set the following variables correspondingly to run this script:

# MODEL_VERSION=vicuna-v1-3-7b
# MODEL_VERSION=llama-2-7b-chat
MODEL_VERSION=mistralai/Mistral-7B-v0.1
#MODEL_VERSION=./BakLLaVA-1

########### DO NOT CHANGE ###########
########### USE THIS FOR BOTH ###########
PROMPT_VERSION=plain
########### DO NOT CHANGE ###########

#1. Prep Model Weights
#2. Data Download + path
#3. images download + path

#!/bin/bash

deepspeed llava/train/train_mem.py \
    --deepspeed ./scripts/zero2.json \
    --model_name_or_path $MODEL_VERSION \
    --version plain \
    --data_path pretrain_data/chat/blip_laion_cc_sbu_558k.json \
    --image_folder pretrain_data/images \
    --vision_tower wkcn/TinyCLIP-ViT-8M-16-Text-3M-YFCC15M \
    --mm_projector_type mlp2x_gelu \
    --tune_mm_mlp_adapter True \
    --mm_vision_select_layer -2 \
    --mm_use_im_start_end False \
    --mm_use_im_patch_token False \
    --bf16 True \
    --output_dir ./checkpoints/test-pretrain \
    --num_train_epochs 1 \
    --per_device_train_batch_size 32 \
    --per_device_eval_batch_size 4 \
    --gradient_accumulation_steps 1 \
    --evaluation_strategy "no" \
    --save_strategy "steps" \
    --save_steps 24000 \
    --save_total_limit 1 \
    --learning_rate 1e-3 \
    --weight_decay 0. \
    --warmup_ratio 0.03 \
    --lr_scheduler_type "cosine" \
    --logging_steps 1 \
    --tf32 True \
    --model_max_length 8000 \
    --gradient_checkpointing True \
    --dataloader_num_workers 4 \
    --lazy_preprocess True \
    --report_to wandb
    
# deepspeed llava/train/train_mem.py \
#     --deepspeed ./scripts/zero2.json \
#     --model_name_or_path $MODEL_VERSION \
#     --version $PROMPT_VERSION \
#     --data_path pretrain_data/chat/chat.json \
#     --image_folder pretrain_data/images \
#     --vision_tower openai/clip-vit-large-patch14 \
#     --tune_mm_mlp_adapter True \
#     --mm_vision_select_layer -2 \
#     --mm_use_im_start_end False \
#     --mm_use_im_patch_token False \
#     --bf16 True \
#     --output_dir ./checkpoints/llava-$MODEL_VERSION-pretrain \
#     --num_train_epochs 1 \
#     --per_device_train_batch_size 16 \
#     --per_device_eval_batch_size 4 \
#     --gradient_accumulation_steps 1 \
#     --evaluation_strategy "no" \
#     --save_strategy "steps" \
#     --save_steps 24000 \
#     --save_total_limit 1 \
#     --learning_rate 2e-3 \
#     --weight_decay 0. \
#     --warmup_ratio 0.03 \
#     --lr_scheduler_type "cosine" \
#     --logging_steps 1 \
#     --tf32 True \
#     --model_max_length 4096 \
#     --gradient_checkpointing True \
#     --dataloader_num_workers 4 \
#     --lazy_preprocess True \
#     --report_to wandb
