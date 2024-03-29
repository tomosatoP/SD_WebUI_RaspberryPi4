# AUTOMATIC1111用モデルデータを集める
[hugging face](https://huggingface.co/models?pipeline_tag=text-to-image&sort=downloads) に、Stable Diffusion Checkpoint ファイルが無い場合の対処方法。

Stable Diffusion Chekcpoint(*.safetensors) <- Hugging Face Diffusers Files

## 準備
|username|hostname|foldername|
|---|---|---|
|user|host|ConvModel|
~~~sh
user@host:~$ sudo apt update
user@host:~$ sudo apt install python3-pip

user@host:~$ python3 -m venv ConvModel/venv --upgrade-deps
(venv) user@host:~/ConvModel$ pip install -U psutil wheel
(venv) user@host:~/ConvModel$ pip install -U accelerate diffusers torch transformers
~~~

~~~sh
(venv) user@host:~/ConvModel$ wget https://raw.githubusercontent.com/tomosatoP/SD_WebUI_RaspberryPi4/main/hf-diffusers-model/files.txt
(venv) user@host:~/ConvModel$ wget -i files.txt
~~~

[convert_diffusers_to_original_stable_diffusion.py](https://raw.githubusercontent.com/huggingface/diffusers/main/scripts/convert_diffusers_to_original_stable_diffusion.py)
- Script for converting a HF Diffusers saved pipeline to a Stable Diffusion checkpoint.
- *Only* converts the UNet, VAE, and Text Encoder.
- Does not convert optimizer state or any other thing.

[ConvModel.sh](ConvModel.sh)
- モデルをダウンロードして、AUTOMATIC1111 用に一つにまとめた safetensors ファイルを作成

[download_diffusers.py](download_diffusers.py)
- [hugging face](https://huggingface.co/models?pipeline_tag=text-to-image&sort=downloads) から diffusers モデルを safetensors 形式でダウンロード

## AUTOMATIC1111用にモデルデータをダウンロード＆変換
~~torch.float16 に変換: 16bitの浮動小数点精度がデフォルトの扱いらしい~~<br>
ema, pruned とか判らないので、対応無し
~~~sh
(venv) user@host:~/ConvModel$ bash ConvModel.sh
~~~
---
