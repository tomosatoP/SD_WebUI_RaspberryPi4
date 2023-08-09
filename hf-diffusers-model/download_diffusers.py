"""Convert a pickle format model to a safetensor format model.

sudo apt install python3-pip
sudo -H python3 -m pip install -U pip setuptools wheel
sudo -H python3 -m pip install torch diffusers transformsers accelerate
"""

from diffusers import StableDiffusionPipeline
import torch
import argparse
import sys


# model_id = "stabilityai/stable-diffusion-2-1"


def convert(model_id: str) -> bool:
    try:
        print(f"Start downloading the model: {model_id}")

        pipe = StableDiffusionPipeline.from_pretrained(
            model_id,
            cache_dir=f"model/{model_id}",
            # revision="fp16",
            # torch_dtype=torch.float16
        )

        print("converting pickles to safetensors ...")

        pipe.save_pretrained(f"model_main/{model_id}", safe_serialization=True)

    except:
        print("Error: download failed and will be interrupted.")
        return False

    else:
        print("Download completed.")
        return True


if __name__ == "__main__":
    parser = argparse.ArgumentParser(
        description="Download model in safetensors format."
    )
    parser.add_argument(
        "--model_id",
        required=True,
        type=str,
        nargs="?",
        help="Path to the model to convert.",
    )

    args = parser.parse_args()

    sys.exit(0) if convert(args.model_id) else sys.exit(1)
