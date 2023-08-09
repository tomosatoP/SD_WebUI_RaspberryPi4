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
torch.backends.cuda.matmul.allow_tf32 = True

def convert(model_id: str, revision: str, output_dir: str) -> bool:
    try:
        print(f"Start downloading the model: {model_id}")

        pipe = StableDiffusionPipeline.from_pretrained(
            model_id,
            cache_dir=f"cache/{model_id}",
            revision=revision,
            # torch_dtype=torch.float16,
            # revision="main",
            # torch_dtype=torch.float32,
        )

        print("converting pickles to safetensors ...")

        pipe.save_pretrained(f"{output_dir}/{model_id}", safe_serialization=True)

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

    parser.add_argument(
        "--revision",
        required=True,
        type=str,
        nargs="?",
        help="Model revision, e.g., 'main'.",
    )

    parser.add_argument(
        "--output_dir",
        required=True,
        type=str,
        nargs="?",
        help="Path to output.",
    )

    args = parser.parse_args()

    sys.exit(0) if convert(args.model_id, args.revision, args.output_dir) else sys.exit(1)
