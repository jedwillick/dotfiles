#!/usr/bin/env bash

sudo add-apt-repository -y ppa:git-core/ppa
sudo apt update
sudo apt upgrade -y
sudo apt install -y git build-essential jq python3-pip zip unzip valgrind cowsay cmake

pip install --upgrade pip setuptools tqdm autopep8 Pygments

# Install Oh-My-Posh
sudo wget -q --show-progress https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download/posh-linux-amd64 -O /usr/local/bin/oh-my-posh
sudo chmod +x /usr/local/bin/oh-my-posh

# Oh-My-Posh Themes
mkdir -p ~/.poshthemes
wget -q --show-progress https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download/themes.zip -O ~/.poshthemes/themes.zip
unzip -oqq ~/.poshthemes/themes.zip -d ~/.poshthemes
chmod u+rw ~/.poshthemes/*.json
rm ~/.poshthemes/themes.zip
