#!/bin/sh

if [ $# -ne 2 ]; then
  echo "Error: usage - sh $0 <model_id> <output_dir>"
  exit 1
elif [ ! -e $2 ]; then
  echo "Error: No $2 was found."
  exit 2
fi

python3 download_diffusers.py --model_id $1

if [ $? -ne 0 ]; then
  exit 3
fi

if [ ! -e $2/$1 ]; then
  echo "mkdir -p $2/$1"
  mkdir -p $2/$1
fi

echo 'Combine safetensors files into one.'
python3 convert_diffusers_to_original_stable_diffusion.py \
  --model_path model_main/$1 \
  --checkpoint_path $2/$1/model_main.safetensors \
  --use_safetensors \
#  --half


if [ $? -eq 0 ]; then
  echo 'Completed.'
  echo `ls -lh $2/$1/model_main.safetensors`
  echo 'Delete folders that are no longer needed.'
  rm -rf model/$1
  rm -rf model_main/$1
else
  echo 'Error: Could not combine files into one.'
  exit 4
fi

exit 0
