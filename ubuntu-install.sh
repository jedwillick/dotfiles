#!/usr/bin/env bash

sudo add-apt-repository -y ppa:git-core/ppa
sudo apt update
sudo apt upgrade -y
sudo apt install -y git build-essential jq python3-pip zip unzip valgrind cowsay cmake clang-format-12 subversion

file=$(command -v clang-format-12) && sudo ln -sf clang-format-12 ${file%-12}
file=$(command -v clang-format-diff-12) && sudo ln -sf clang-format-diff-12 ${file%-12}

pip install --upgrade -r pip-packages.txt

# Install Oh-My-Posh
sudo wget -q --show-progress https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download/posh-linux-amd64 -O /usr/local/bin/oh-my-posh
sudo chmod +x /usr/local/bin/oh-my-posh

# Oh-My-Posh Themes
mkdir -p ~/.poshthemes
wget -q --show-progress https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download/themes.zip -O ~/.poshthemes/themes.zip
unzip -oqq ~/.poshthemes/themes.zip -d ~/.poshthemes
chmod u+rw ~/.poshthemes/*.json
rm ~/.poshthemes/themes.zip
