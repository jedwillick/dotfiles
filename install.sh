#!/usr/bin/env bash

set -eu

WGET="wget -q --show-progress"
APT="sudo apt -y"

TMP=$(mktemp -d)
chmod 777 "$TMP"

trap 'rm -rf "$TMP"' EXIT

install_apt() {
  ppas=(
    git-core/ppa
    neovim-ppa/unstable # Neovim nightly
  )
  packages=(
    git
    build-essential
    jq
    python3-pip
    zip
    unzip
    valgrind
    cowsay
    cmake
    subversion
    dos2unix
    ncat
    python3-venv
    sqlite3
    curl
    wget
    neovim
    stow
    tree
    net-tools
    traceroute
    ncdu
    universal-ctags
  )

  $APT install software-properties-common

  for ppa in "${ppas[@]}"; do
    sudo add-apt-repository -y "ppa:$ppa"
  done

  $APT update
  $APT upgrade

  $APT install "${packages[@]}"
}

install_debs() {
  DEBS=(
    'https://github.com/sharkdp/fd/releases/latest/download/fd_8.4.0_amd64.deb'
    'https://github.com/sharkdp/bat/releases/latest/download/bat_0.21.0_amd64.deb'
    'https://github.com/BurntSushi/ripgrep/releases/latest/download/ripgrep_13.0.0_amd64.deb'
    'https://github.com/sharkdp/hyperfine/releases/latest/download/hyperfine_1.14.0_amd64.deb'
    'https://github.com/cli/cli/releases/latest/download/gh_2.14.4_linux_amd64.deb'
  )

  for deb in "${DEBS[@]}"; do
    dest="$TMP/$(basename "$deb")"
    $WGET "$deb" -O "$dest" && $APT install "$dest"
  done
}

install_nvm() {
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash
  if [[ -z "${NVM_DIR:-}" ]]; then
    export NVM_DIR="$HOME/.nvm"
  fi
  source "$NVM_DIR/nvm.sh"

  nvm install 17
  nvm use 17
  npm install --location=global tree-sitter-cli prettier neovim markdownlint markdownlint-cli
}

install_go() {
  GO="go1.18.4.linux-amd64.tar.gz"
  $WGET https://go.dev/dl/$GO -O "$TMP/$GO"
  sudo rm -rf /usr/local/go
  sudo tar -C /usr/local -xzf "$TMP/$GO"

  GO=/usr/local/go/bin/go
  if [[ -z "${GOPATH-}" ]]; then
    export GOPATH=~/.local/go
  fi

  $GO install mvdan.cc/sh/v3/cmd/shfmt@latest
}

install_ohmyposh() {
  # Install Oh-My-Posh
  $WGET https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download/posh-linux-amd64 -O "$TMP/oh-my-posh"
  sudo mv "$TMP/oh-my-posh" /usr/local/bin/oh-my-posh
  sudo chmod +x /usr/local/bin/oh-my-posh

  # Oh-My-Posh Themes
  mkdir -p ~/.poshthemes
  $WGET https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download/themes.zip -O ~/.poshthemes/themes.zip
  unzip -oqq ~/.poshthemes/themes.zip -d ~/.poshthemes
  chmod u+rw ~/.poshthemes/*.json
  rm ~/.poshthemes/themes.zip
}

install_fzf() {
  if [[ -d ~/.fzf ]]; then
    git -C ~/.fzf pull
  else
    git clone -q --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
  fi
  ~/.fzf/install --all
}

install_wsl() {
  # WSL Only
  if [[ -z "${WSL_DISTRO_NAME-}" ]]; then
    echo "Not running on WSL"
    return 1
  fi

  # WIN32 Yank for Nvim
  $WGET https://github.com/equalsraf/win32yank/releases/download/v0.0.4/win32yank-x64.zip -O "$TMP/win32yank.zip"
  unzip -p "$TMP/win32yank.zip" win32yank.exe >"$TMP/win32yank.exe"
  chmod +x "$TMP/win32yank.exe"
  sudo mv "$TMP/win32yank.exe" /usr/local/bin/
}

install_pip() {
  python3 -m pip install --upgrade pip
  pip install --upgrade -r pip-packages.txt pynvim
}

case "${1-}" in
  apt)
    install_apt
    ;;
  debs)
    install_debs
    ;;
  nvm)
    install_nvm
    ;;
  go)
    install_go
    ;;
  ohmyposh)
    install_ohmyposh
    ;;
  fzf)
    install_fzf
    ;;
  wsl)
    install_wsl
    ;;
  pip)
    install_pip
    ;;
  all)
    install_apt
    install_debs
    install_nvm
    install_go
    install_ohmyposh
    install_fzf
    install_wsl
    install_pip
    ;;
  *)
    echo "Usage: $0 {apt|debs|nvm|go|ohmyposh|fzf|wsl|pip|all}"
    exit 1
    ;;
esac

exit 0
