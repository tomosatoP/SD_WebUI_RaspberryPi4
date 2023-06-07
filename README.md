# AUTOMATIC1111_on_RaspberryPi4
Raspberry Pi 4 で AUTOMATIC1111 を動かす

### ハードウェア
- Raspberry Pi 4B 8GB x 3
- microSD Card 64GB x 3
### ソフトウェア
- Raspberry Pi OS 64bit Lite
### スクリーンショット
![htop](image/htom.png)
![ssh](image/ssh.png)
![webui](image/webui.png)

## AUTOMATIC1111/stable-diffusion-webui
https://github.com/AUTOMATIC1111/stable-diffusion-webui<br>
https://github.com/AUTOMATIC1111/stable-diffusion-webui/wiki<br>
https://github.com/AUTOMATIC1111/stable-diffusion-webui/wiki/Features#alt-diffusion<br>
https://github.com/AUTOMATIC1111/stable-diffusion-webui/wiki/Features#stable-diffusion-20

### memory 確保
CPUのみで実行するには最低でもメモリが16GB以上必要らしい。
~~~diff
~ $ sudo nano /etc/dphys-swapfile
~~~
~~~diff
- CONF_SWAPSIZE=100
+ CONF_SWAPSIZE=8192
- #CONF_MAXSWAP=2048
+ CONF_MAXSWAP=8192
~~~
~~~sh
~ $ sudo systemctl restart dphys-swapfile
# モニタリング
~ $ htop
~~~
### install on Linux without CUDA
~~~sh
~ $ sudo apt install wget git python3 python3-venv python3-pip libgl1-mesa-dev
~ $ sudo -H python3 -m pip install -U pip
~ $ git clone -b master https://github.com/AUTOMATIC1111/stable-diffusion-webui.git WebSD
~/WebSD $ python3 -m venv venv --upgrade-deps
~/WebSD $ . venv/bin/activate
# Pytorch のインストール（最新版になってる！）
(venv) ~/WebSD $ pip install -U torch torchvision torchaudio
# その他のモジュールをアップデート
(venv) ~/WebSD $ pip install -U psutil
# 設定: GPU無し, インストール済みのPytorch使用, xformers無し, accelerateは必要か？
(venv) ~/WebSD $ nano webui-user.sh
~~~
[webui-user.sh](src/webui-user.sh)
~~~sh
# install and run
(venv) ~/WebSD $ bash webui.sh --listen
~~~

### accelerate を有効化(export ACCELERATE="True")したい場合
注意：設定内容が正しいのか検証してません。
~~~sh
(venv) ~/WebSD $ accelerate config
~~~
~~~txt
--------------------------------
In which compute environment are you running?
This machine
--------------------------------
Which type of machine are you using?
multi-CPU
How many different machines will you use (use more than 1 for multi-node training)? [1]: 1
Do you wish to optimize your script with torch dynamo?[yes/NO]:NO
How many CPU(s) should be used for distributed training? [1]:4
--------------------------------
Do you wish to use FP16 or BF16 (mixed precision)?
no
accelerate configuration saved at /home/xxx/.cache/huggingface/accelerate/default_config.yaml
~~~
[default_config.yaml](src/default_config.yaml)
~~~sh
# 設定の参照
(venv) ~/WebSD $ accelerate env
# 動作確認
(venv) ~/WebSD $ accelerate test
~~~
