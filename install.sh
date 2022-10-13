#!/usr/bin/env bash

set -eu

source ~/.local/share/util.sh

declare TMP
readonly WGET="wget -q --show-progress"
readonly APT="sudo apt -y -qq"

install_apt() {
  if ! exists apt; then
    echo "apt not found... skipping"
    return
  fi

  local ppas=(
    git-core/ppa
    neovim-ppa/unstable # Neovim nightly
  )
  local packages=(
    bear
    build-essential
    cmake
    cowsay
    curl
    dos2unix
    git
    jq
    manpages-posix
    ncat
    ncdu
    neovim
    net-tools
    python3
    python3-pip
    python3-venv
    sqlite3
    subversion
    traceroute
    tree
    universal-ctags
    unzip
    valgrind
    wget
    zip
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
  if ! exists apt; then
    echo "apt not found... skipping"
    return
  fi
  local repos=(
    'BurntSushi/ripgrep'
    'cli/cli'
    'sharkdp/bat'
    'sharkdp/fd'
    'sharkdp/hexyl'
    'sharkdp/hyperfine'
  )
  for repo in "${repos[@]}"; do
    install-from-github -s deb "$repo"
  done
}

install_nvm() {
  $WGET -O- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash
  if [[ -z "${NVM_DIR:-}" ]]; then
    export NVM_DIR="$HOME/.nvm"
  fi
  source "$NVM_DIR/nvm.sh"

  nvm install 17
  nvm use 17
  npm install --location=global tree-sitter-cli neovim
}

install_go() {
  GO="go1.19.2.linux-amd64.tar.gz"
  $WGET https://go.dev/dl/$GO -O "$TMP/$GO"
  sudo rm -rf /usr/local/go
  sudo tar -C /usr/local -xzf "$TMP/$GO"
}

install_ohmyposh() {
  install-from-github -s binary "jandedobbeleer/oh-my-posh"
  sudo mv "$HOME/.local/bin/oh-my-posh" /usr/local/bin/oh-my-posh

  # Oh-My-Posh Themes
  mkdir -p ~/.poshthemes
  $WGET https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download/themes.zip -O ~/.poshthemes/themes.zip
  unzip -oqq ~/.poshthemes/themes.zip -d ~/.poshthemes
  chmod u+rw ~/.poshthemes/*.omp.*
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
    echo "Not running on WSL... skipping"
    return
  fi

  # WIN32 Yank for Nvim
  $WGET https://github.com/equalsraf/win32yank/releases/download/v0.0.4/win32yank-x64.zip -O "$TMP/win32yank.zip"
  unzip -p "$TMP/win32yank.zip" win32yank.exe > "$TMP/win32yank.exe"
  chmod +x "$TMP/win32yank.exe"
  sudo mv "$TMP/win32yank.exe" /usr/local/bin/
}

install_pip() {
  python3 -m pip install --upgrade pip
  pip install --upgrade -r pip-packages.txt pynvim
}

show_help() {
  cat << EOF
USAGE: $0 [-h] [INSTALL]...

If no INSTALL is specified then all will be run.
INSTALL can be any of:
  - apt         Install apt packages.
  - debs        Install deb packages from github.
  - fzf         Install fzf a fuzzy finder.
  - go          Install Golang.
  - nvm         Install Node Version Manager.
  - ohmyposh    Install Oh-My-Posh a prompt theme manager.
  - pip         Install pip packages.
  - wsl         Install WSL specific things, such as win32yank.

OPTIONS:
  -h, --help  Show this help message and exit.
EOF
}

main() {
  local validOptions=(
    apt
    debs
    fzf
    go
    nvm
    ohmyposh
    pip
    wsl
  )

  for arg in "$@"; do
    if [[ "$arg" == "-h" || "$arg" == "--help" ]]; then
      show_help
      exit 0
    fi

    # shellcheck disable=2076
    if [[ ! " ${validOptions[*]} " =~ " ${arg} " ]]; then
      echo "Invalid option: $arg" >&2
      echo "Usage: $0 [-h] [$(
        IFS='|'
        printf "%s" "${validOptions[*]}"
      )]..." >&2
      exit 1
    fi
  done

  if [[ $# -eq 0 ]]; then
    set -- "${validOptions[@]}"
  fi

  TMP=$(mktemp -d)
  readonly TMP
  chmod 777 "$TMP"
  trap 'rm -rf "$TMP"' EXIT

  for arg in "$@"; do
    "install_$arg"
  done
}

main "$@"
