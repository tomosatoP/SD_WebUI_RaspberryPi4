# AUTOMATIC1111 with RaspberryPi4
Raspberry Pi 4 で AUTOMATIC1111 を動かす

### ハードウェア
- Raspberry Pi 4B 8GB
- microSD Card 64GB
### ソフトウェア
- Raspberry Pi OS 64bit Lite
### スクリーンショット
![htop](image/htom.png)<br>
![ssh](image/ssh.png)<br>
![webui](image/webui.png)<br>
> 1時間20分もかかった。

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
# 設定: GPU無し, インストール済みのPytorch使用, xformers無し, accelerate無し
(venv) ~/WebSD $ nano webui-user.sh
~~~
[webui-user.sh](src/webui-user.sh)
~~~sh
# install and run
(venv) ~/WebSD $ bash webui.sh --listen
~~~
