#!/usr/bin/env bash

TMP=$(mktemp -d)
chmod 777 $TMP

WGET_OPTS="-q --show-progress"

sudo apt update
sudo apt install -y software-properties-common

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
  'https://github.com/sharkdp/fd/releases/download/v8.4.0/fd_8.4.0_amd64.deb'
  'https://github.com/sharkdp/bat/releases/download/v0.21.0/bat_0.21.0_amd64.deb'
  'https://github.com/BurntSushi/ripgrep/releases/download/13.0.0/ripgrep_13.0.0_amd64.deb'
)

for i in "${DEBS[@]}"; do
  dest="$TMP/$(basename ${i})"
  wget ${WGET_OPTS} ${i} -O ${dest} && sudo apt install ${dest}
done

curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash && echo "Run 'nvm install node'" || echo "Unable to install nvm"

#Install Go
GO="go1.18.3.linux-amd64.tar.gz"
wget ${WGET_OPTS} https://go.dev/dl/$GO -O $TMP/$GO && sudo rm -rf /usr/local/go && sudo tar -C /usr/local -xzf $TMP_DIR/$GO
if command -v go &>/dev/null; then
  go install mvdan.cc/sh/v3/cmd/shfmt@latest
fi

# Symlink without the "-12" suffix
file=$(command -v clang-format-12) && sudo ln -sf clang-format-12 ${file%-12}
file=$(command -v clang-format-diff-12) && sudo ln -sf clang-format-diff-12 ${file%-12}

python3 -m pip install --upgrade pip
pip install --upgrade -r pip-packages.txt

# Install Oh-My-Posh
wget ${WGET_OPTS} https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download/posh-linux-amd64 -O $TMP/omp && sudo mv $TMP_DIR/omp /usr/local/bin/oh-my-posh
sudo chmod +x /usr/local/bin/oh-my-posh

# Oh-My-Posh Themes
mkdir -p ~/.poshthemes
wget ${WGET_OPTS} https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download/themes.zip -O ~/.poshthemes/themes.zip
unzip -oqq ~/.poshthemes/themes.zip -d ~/.poshthemes
chmod u+rw ~/.poshthemes/*.json
rm ~/.poshthemes/themes.zip

# FZF
git -C ~/.fzf pull || git -q clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf && ~/.fzf/install --all

# WSL Only
if [[ -n $WSL_DISTRO_NAME ]]; then
  # WIN32 Yank for Nvim
  curl -sLo$TMP/win32yank.zip https://github.com/equalsraf/win32yank/releases/download/v0.0.4/win32yank-x64.zip
  unzip -p $TMP/win32yank.zip win32yank.exe >"$TMP/win32yank.exe"
  chmod +x $TMP/win32yank.exe
  sudo mv $TMP/win32yank.exe /usr/local/bin/
fi

rm -rf $TMP
exit 0
