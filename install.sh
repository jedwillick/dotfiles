#!/usr/bin/env bash

source ~/.local/share/util.sh

set -u

declare TMP
readonly BASH_COMP=~/.local/share/bash-completion/completions
export _MSG=""

_apt() {
  sudo apt -y -q=3 -o apt::cmd::disable-script-warning=1 "$@"
}

log_working() {
  printf "[ \x1b[1;34mWORKING\x1b[0m ] %s...\n" "$1"
  _MSG="$1"
}

log_success() {
  printf "[ \x1b[1;32mSUCCESS\x1b[0m ] %s\n" "$1"
}

log_failed() {
  printf "[ \x1b[1;31mFAILED\x1b[0m  ] %s\n" "$1"
}

log_info() {
  printf "[  \x1b[1;36mINFO\x1b[0m   ] %s\n" "$1"
}

log_warn() {
  printf "[ \x1b[33mWARNING\x1b[0m ] %s\n" "$1"
}

log_done() {
  if [[ "$?" -eq 0 ]]; then
    log_success "$_MSG"
  else
    log_failed "$_MSG"
  fi

}

install_apt() {
  if ! exists apt; then
    log_warn "apt not found... skipping"
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
    fortune
    gdb
    git
    jq
    lolcat
    manpages-posix
    ncat
    ncdu
    neovim
    net-tools
    python3
    python3-pip
    python3-venv
    rlwrap
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

  _apt install software-properties-common

  for ppa in "${ppas[@]}"; do
    log_working "Adding ppa $ppa"
    sudo add-apt-repository -y "ppa:$ppa"
    log_done
  done

  log_working "apt update & upgrade"
  _apt update && _apt upgrade
  log_done

  log_working "Installing apt packages"
  _apt install "${packages[@]}"
  log_done
}

install_debs() {
  if ! exists apt; then
    log_warn "apt not found... skipping"
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
  set +e
  for repo in "${repos[@]}"; do
    log_working "Installing $repo"
    install-from-github -s deb "$repo"
    log_done
  done

  gh completion -s bash > "$BASH_COMP/gh"
}

install_nvm() {
  log_working "Installing nvm"
  curl -Lo- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash > /dev/null
  log_done
  if [[ -z "${NVM_DIR:-}" ]]; then
    export NVM_DIR="$HOME/.nvm"
  fi
  source "$NVM_DIR/nvm.sh"

  log_working "Installing node"
  nvm install 17
  log_done

  log_working "Installing npm packages"
  npm install --no-fund --location=global tree-sitter-cli neovim
  log_done
}

install_go() {
  GO="go1.19.2.linux-amd64.tar.gz"

  log_working "Installing go $(grep -Eo "[0-9]+.[0-9]+.[0-9]+" <<< "$GO")"
  curl -Lo "$TMP/$GO" https://go.dev/dl/$GO
  sudo rm -rf /usr/local/go
  sudo tar -C /usr/local -xaf "$TMP/$GO"
  log_done
}

install_ohmyposh() {
  log_working "Installing Oh-My-Posh"
  install-from-github -s binary "jandedobbeleer/oh-my-posh"

  local themes=~/.local/share/poshthemes
  mkdir -p "$themes"
  cd "$themes"
  curl -LO https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download/themes.zip
  unzip -oqq themes.zip
  chmod u+rw ./*.omp.*
  rm themes.zip

  oh-my-posh completion bash > "$BASH_COMP/oh-my-posh"
  log_done
}

install_fzf() {
  log_working "Installing fzf"
  local fzfDir=~/.fzf
  if [[ -d "$fzfDir" ]]; then
    git -C "$fzfDir" pull
  else
    git clone -q --depth 1 https://github.com/junegunn/fzf.git "$fzfDir"
  fi
  "$fzfDir/install" --all --xdg
  log_done
}

install_wsl() {
  # WSL Only
  if [[ -z "${WSL_DISTRO_NAME-}" ]]; then
    log_warn "Not running on WSL... skipping"
    return
  fi

  # WIN32 Yank for Nvim
  log_working "Installing win32yank"
  curl -Lo "$TMP/win32yank.zip" https://github.com/equalsraf/win32yank/releases/download/v0.0.4/win32yank-x64.zip
  unzip -p "$TMP/win32yank.zip" win32yank.exe > "$TMP/win32yank.exe"
  chmod +x "$TMP/win32yank.exe"
  sudo mv "$TMP/win32yank.exe" /usr/local/bin/
  log_done
}

install_pip() {
  log_working "Installing pip"
  python3 -m pip install -q --upgrade pip
  log_done
  log_working "Installing pip packages"
  pip install -q --upgrade -r pip-packages.txt pynvim
  pip completion --bash > "$BASH_COMP/pip"
  log_done
}

install_btop() {
  log_working "Installing btop"
  cd "$TMP"
  curl -Lo btop.tbz https://github.com/aristocratos/btop/releases/latest/download/btop-x86_64-linux-musl.tbz
  tar -xaf "btop.tbz"
  cd btop
  ./install.sh > /dev/null
  log_done
}

install_spotifytui() {
  log_working "Installing spotify-tui"
  # Dependencies
  _apt install pkg-config libssl-dev libxcb1-dev libxcb-render0-dev libxcb-shape0-dev libxcb-xfixes0-dev
  cd "$TMP"
  curl -LO https://github.com/Rigellute/spotify-tui/releases/download/v0.25.0/spotify-tui-linux.tar.gz
  tar -xaf spotify-tui-linux.tar.gz
  mv spt ~/.local/bin/
  spt --completions bash > "$BASH_COMP/spt"
  log_info "Run 'spt' to finish setup"
  log_done
}

show_help() {
  cat << EOF
USAGE: $0 [-h] [INSTALL]...

If no INSTALL is specified then all will be run.
INSTALL can be any of:
  - apt         Install apt packages.
  - btop        Install btop.
  - debs        Install deb packages from github.
  - fzf         Install fzf a fuzzy finder.
  - go          Install Golang.
  - nvm         Install Node Version Manager.
  - ohmyposh    Install Oh-My-Posh a prompt theme manager.
  - pip         Install pip packages.
  - spotifytui  Install spotify-tui a spotify client.
  - wsl         Install WSL specific things, such as win32yank.

OPTIONS:
  -h, --help  Show this help message and exit.
EOF
}

main() {
  local validOptions=(
    apt
    btop
    debs
    fzf
    go
    nvm
    ohmyposh
    pip
    spotifytui
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

  [[ -d "$BASH_COMP" ]] || mkdir "$BASH_COMP"

  for arg in "$@"; do
    (
      set -eo pipefail
      "install_$arg"
    )
    # shellcheck disable=2181
    [[ "$?" -eq 0 ]] || log_failed "install_$arg encountered an error"
  done
}

main "$@"
