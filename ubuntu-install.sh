#!/usr/bin/env bash

TMP=$(mktemp -d)
chmod 777 $TMP

WGET="wget -q --show-progress"

sudo apt update
sudo apt install -y software-properties-common

sudo add-apt-repository -y ppa:git-core/ppa
sudo add-apt-repository -y ppa:neovim-ppa/unstable

sudo apt update
sudo apt upgrade -y
sudo apt autoremove -y

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
  stow \
  tree

DEBS=(
  'https://github.com/sharkdp/fd/releases/download/v8.4.0/fd_8.4.0_amd64.deb'
  'https://github.com/sharkdp/bat/releases/download/v0.21.0/bat_0.21.0_amd64.deb'
  'https://github.com/BurntSushi/ripgrep/releases/download/13.0.0/ripgrep_13.0.0_amd64.deb'
)

for i in "${DEBS[@]}"; do
  dest="$TMP/$(basename ${i})"
  ${WGET} ${i} -O ${dest} && sudo apt install ${dest}
done

curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash && echo "Run 'nvm install node'" || echo "Unable to install nvm"

#Install Go
GO="go1.18.3.linux-amd64.tar.gz"
${WGET} https://go.dev/dl/$GO -O $TMP/$GO && sudo rm -rf /usr/local/go && sudo tar -C /usr/local -xzf $TMP/$GO

# Symlink without the "-12" suffix
file=$(command -v clang-format-12) && sudo ln -sf clang-format-12 ${file%-12}
file=$(command -v clang-format-diff-12) && sudo ln -sf clang-format-diff-12 ${file%-12}

# Install Oh-My-Posh
${WGET} https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download/posh-linux-amd64 -O $TMP/omp && sudo mv $TMP/omp /usr/local/bin/oh-my-posh
sudo chmod +x /usr/local/bin/oh-my-posh

# Oh-My-Posh Themes
mkdir -p ~/.poshthemes
${WGET} https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download/themes.zip -O ~/.poshthemes/themes.zip
unzip -oqq ~/.poshthemes/themes.zip -d ~/.poshthemes
chmod u+rw ~/.poshthemes/*.json
rm ~/.poshthemes/themes.zip

# FZF
git -C ~/.fzf pull 2>/dev/null || git clone -q --depth 1 https://github.com/junegunn/fzf.git ~/.fzf && ~/.fzf/install --all

# WSL Only
if [[ -n $WSL_DISTRO_NAME ]]; then
  # WIN32 Yank for Nvim
  ${WGET} https://github.com/equalsraf/win32yank/releases/download/v0.0.4/win32yank-x64.zip -O $TMP/win32yank.zip
  unzip -p $TMP/win32yank.zip win32yank.exe >"$TMP/win32yank.exe"
  chmod +x $TMP/win32yank.exe
  sudo mv $TMP/win32yank.exe /usr/local/bin/
fi

rm -rf $TMP

echo "Ensure you 'source ~/.bashrc'"
exit 0
