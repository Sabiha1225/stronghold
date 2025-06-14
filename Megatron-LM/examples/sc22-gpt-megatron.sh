#! /bin/bash

# Runs the "345M" parameter model
# rm -rf ./checkpoints/*
rm -rf /home/sabiha/stronghold/checkpoints/*

RANK=0
WORLD_SIZE=1

export PYTORCH_JIT=0 
export MASTER_ADDR=localhost
export MASTER_PORT=6000

# _BASE=/home/sys/STRONGHOLD/data
# DATA_PATH=${_BASE}/my-gpt2-en_text_document
# VOCAB_PATH=${_BASE}/gpt2-vocab.json
# MERGE_PATH=${_BASE}/gpt2-merges.txt
# CHECKPOINT_PATH=checkpoints/gpt2

_BASE=/home/sabiha/stronghold/data
DATA_PATH=${_BASE}/my-gpt2_text_document
VOCAB_PATH=${_BASE}/gpt2-vocab.json
MERGE_PATH=${_BASE}/gpt2-merges.txt
CHECKPOINT_PATH=/home/sabiha/stronghold/checkpoints/gpt2

NLAYERS=${1-12} 
NHIDDEN=${2-2560} 
HEADS=${3-16} 
SEQ=${4-1024} 
BATCHSIZE=${5-4} 
LOGDIR="tensorboard_data/${NLAYERS}l_${NHIDDEN}h_${NNODES}n_${GPUS_PER_NODE}g_${mp_size}mp_${BATCHSIZE}b_ds4" 

PYTHONGIL=1 python pretrain_gpt.py \
       --num-layers ${NLAYERS} \
       --hidden-size ${NHIDDEN} \
       --num-attention-heads ${HEADS} \
       --micro-batch-size ${BATCHSIZE} \
       --global-batch-size ${BATCHSIZE} \
       --seq-length ${SEQ} \
       --max-position-embeddings ${SEQ} \
       --train-iters 100 \
       --log-interval 10 \
       --exit-interval 100 \
       --lr-decay-iters 320000 \
       --save $CHECKPOINT_PATH \
       --data-path $DATA_PATH \
       --vocab-file ${VOCAB_PATH} \
       --merge-file ${MERGE_PATH} \
       --data-impl mmap \
       --split 949,50,1 \
       --distributed-backend nccl \
       --lr 0.00015 \
       --min-lr 1.0e-5 \
       --lr-decay-style cosine \
       --weight-decay 1e-2 \
       --clip-grad 1.0 \
       --lr-warmup-fraction .01 \
       --activations-checkpoint-method uniform \
       --save-interval 10000 \
       --eval-interval 1000 \
       --eval-iters 1000 

# --load $CHECKPOINT_PATH \
