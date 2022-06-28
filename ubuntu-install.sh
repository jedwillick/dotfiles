#!/usr/bin/env bash

sudo apt update
sudo apt install -y software-properties-common

sudo add-apt-repository -y ppa:neovim-ppa/unstable
sudo add-apt-repository -y ppa:git-core/ppa

sudo apt update

sudo apt install -y \
    git \
    build-essential \
    jq \
    python3-pip \
    zip \
    unzip \
    valgrind \
    cowsay \
    cmake \
    clang-format-12 \
    subversion \
    dos2unix \
    ncat \
    python3-venv \
    sqlite3 \
    curl \
    wget \
    neovim \
    stow

DEBS=(
  'https://github.com/sharkdp/bat/releases/download/v0.21.0/bat_0.21.0_amd64.deb'
  'https://github.com/BurntSushi/ripgrep/releases/download/13.0.0/ripgrep_13.0.0_amd64.deb'
)
for i in "${DEBS[@]}"; do
  dest="/tmp/$(basename ${i})"
  wget -q --show-progress ${i} -O ${dest} && sudo apt install ${dest}
  rm -f ${dest}
done

curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash && echo "Run 'nvm install node'" || echo "Unable to install nvm"

# Symlink without the "-12" suffix
file=$(command -v clang-format-12) && sudo ln -sf clang-format-12 ${file%-12}
file=$(command -v clang-format-diff-12) && sudo ln -sf clang-format-diff-12 ${file%-12}

python3 -m pip install --upgrade pip
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

# FZF
git -C ~/.fzf pull || git -q clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf && ~/.fzf/install --all

exit 0
