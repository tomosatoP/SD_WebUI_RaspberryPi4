#!/bin/bash

# After downloading the model in HF-Diffusers format from the huggingface website,
# convert it to a stable-diffusion format model.

set -Eeuo pipefail

trap catch ERR
trap quit SIGINT


function catch {
  echo "$?"
}

function quit {
  echo '\nCtl-c was pressed.'
}

declare -A FILES

FILES["stabilityai/stable-diffusion-2-1"]="stable-diffusion-2-1.safetensors"
FILES["runwayml/stable-diffusion-v1-5"]="stable-diffusion-v1-5.safetensors"
FILES["CompVis/stable-diffusion-v1-4"]="stable-diffusion-v1-4.safetensors"

FILES["stablediffusionapi/anything-v5"]="stablediffusionapi-anything-v5.safetensors"
FILES["xyn-ai/anything-v4.0"]="xyn-ai-anything-v4.safetensors"
FILES["Linaqruf/anything-v3.0"]="Linaqruf-anything-v3.safetensors"

FILES["hakurei/waifu-diffusion"]="waifu-diffusion.safetensors"
FILES["dreamlike-art/dreamlike-anime-1.0"]="dreamlike-anime-1-0.safetensors"
FILES["eimiss/EimisAnimeDiffusion_1.0v"]="EimisAnimeDiffusion-1-0v.safetensors"
FILES["gsdf/Counterfeit-V2.5"]="gsdf-Counterfeit-v2-5.safetensors"
FILES["Ojimi/anime-kawai-diffusion"]="Ojimi-anime-kawai-diffusion.safetensors"


diffusers_dir="diffusers"
checkpoints_dir="checkpoints"

for diffusers in "${!FILES[@]}"; do
  safetensors="${FILES[$diffusers]}"

  if [ ! -e "${checkpoints_dir}/${safetensors}" ]; then

    python3 download_diffusers.py \
      --model_id "${diffusers}" \
      --revision "main" \
      --output_dir "${diffusers_dir}"

    echo 'Combine safetensors files into one.'
    python3 convert_diffusers_to_original_stable_diffusion.py \
      --model_path "${diffusers_dir}"/"${diffusers}" \
      --checkpoint_path "${checkpoints_dir}"/"${safetensors}" \
      --use_safetensors

    echo 'Completed.'
    echo `ls -lh "${checkpoints_dir}/${safetensors}"`
    echo 'Delete folders that are no longer needed.'
    rm -rf cache/"${diffusers}"
    rm -rf "${diffusers_dir}"/"${diffusers}"
  fi
done

echo 'All completed.'
