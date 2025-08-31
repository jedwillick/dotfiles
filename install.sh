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

install_packages() {
  if exists apt; then
    _install_apt
  elif exists dnf; then
    _install_dnf
  elif exists pacman; then
    _install_arch
  else
    log_warn "Unknown package manager.... skipping"
  fi
}

_install_arch() {
  local packages=(
    base-devel
    ripgrep
    fd
    direnv
    jq
    zoxide
    github-cli
    hexyl
    bat
  )
  log_working "Updating packages and refreshing mirrors"
  sudo pacman -Syyu
  log_done
  log_working  "Installing pacman packages"
  sudo pacman -Syy "${packages[@]}"
}

_install_dnf() {
  local packages=(
    dnf5-plugins
    direnv
    jq
    ripgrep
    zoxide
    fd-find
    @development-tools
    @c-development
  )

  log_working "Installing dnf packages"
  sudo dnf install "${packages[@]}"
  log_done

  # Github CLI
  sudo dnf config-manager addrepo --from-repofile=https://cli.github.com/packages/rpm/gh-cli.repo --overwrite
  sudo dnf install gh --repo gh-cli
}

install_apt() {
  local ppas=(
    git-core/ppa
  )
  local packages=(
    bear
    build-essential
    cmake
    cowsay
    curl
    direnv
    dos2unix
    fortune
    gdb
    git
    jq
    #    keychain
    libsqlite3-dev
    #   lolcat
    manpages-posix
    ncat
    ncdu
    neovim
    net-tools
    # python3
    # python3-pip
    # python3-venv
    rlwrap
    sqlite3
    traceroute
    tree
    universal-ctags
    unzip
    valgrind
    wget
    zip
  )

  sudo apt-get update
  sudo apt-get install --reinstall python3-apt

  if ! exists apt; then
    log_warn "apt not found... skipping"
    return
  fi

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
    'ajeetdsouza/zoxide'
  )
  set +e
  for repo in "${repos[@]}"; do
    log_working "Installing $repo"
    install-from-github -s deb "$repo"
    log_done
  done

  gh completion -s bash > "$BASH_COMP/gh"
}

install_node() {
  log_working "Installing fnm"
  curl -LO https://github.com/Schniz/fnm/releases/latest/download/fnm-linux.zip
  unzip fnm-linux.zip
  chmod +x fnm
  cp fnm ~/.local/bin/fnm
  eval "$(fnm env --use-on-cd)"
  log_done

  log_working "Installing node"
  fnm use lts/* --install-if-missing
  log_done

  log_working "Installing npm packages"
  npm install --no-fund -g npm
  npm install --no-fund --location=global tree-sitter-cli neovim
  log_done
}

install_go() {
  GO="go1.21.5.linux-amd64.tar.gz"

  log_working "Installing go $(grep -Eo "[0-9]+.[0-9]+.[0-9]+" <<< "$GO")"
  curl -Lo "$GO" https://go.dev/dl/$GO
  sudo rm -rf /usr/local/go
  sudo tar -C /usr/local -xaf "$GO"
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
  "$fzfDir/install" --all --xdg --no-fish
  log_done
}

install_pip() {
  log_working "Installing pip"
  python3 -m pip install -q --upgrade pip
  log_done
  log_working "Installing pip packages"
  pip install -q --upgrade -r "$DOTFILES/pip-packages.txt" pynvim
  pip completion --bash > "$BASH_COMP/pip"
  log_done
}

install_btop() {
  log_working "Installing btop"
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
  curl -LO https://github.com/Rigellute/spotify-tui/releases/download/v0.25.0/spotify-tui-linux.tar.gz
  tar -xaf spotify-tui-linux.tar.gz
  mv spt ~/.local/bin/
  spt --completions bash > "$BASH_COMP/spt"
  log_info "Run 'spt' to finish setup"
  log_done
}

install_lazygit() {
  log_working "Installing lazygit"
  LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep '"tag_name":' | sed -E 's/.*"v*([^"]+)".*/\1/')
  curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
  sudo tar xf lazygit.tar.gz -C /usr/local/bin lazygit
  log_done
}

install_neovim() {
  # log_working "Installing neovim"
  # # sudo add-apt-repository -y ppa:neovim-ppa/unstable > /dev/null
  # sudo add-apt-repository -y ppa:neovim-ppa/stable > /dev/null
  # _apt update && _apt install neovim
  # log_done
  # log_working "Installing plugins and TS parsers"
  # nvim --headless "+Lazy! install" "+MasonUpdate" +qa
  # log_done
  # WSL Only
  if [[ -n "${WSL_DISTRO_NAME-}" ]]; then
    log_working "Installing clipboard provider: win32yank"
    curl -LO https://github.com/jedwillick/win32yank/releases/download/latest/win32yank.exe
    chmod +x win32yank.exe
    sudo mv win32yank.exe /usr/local/bin/win32yank.exe
    log_done
  fi
}

install_fish() {
  log_working "Installing fish"
  sudo apt-add-repository -y ppa:fish-shell/release-3 > /dev/null
  _apt update && _apt install fish
  log_done
  log_working "Installing plugins"
  fish -ic "curl -sL https://git.io/fisher | source && fisher update"
  log_done
}

install_exercism() {
  log_working "Installing exercism"
  curl -Lo exercism.tar.gz https://github.com/exercism/cli/releases/download/v3.1.0/exercism-3.1.0-linux-x86_64.tar.gz
  tar xaf exercism.tar.gz -C ~/.local/bin exercism
  log_done
}

install_haskell() {
  log_working "Installing ghcup"
  curl --proto '=https' --tlsv1.2 -sSf https://get-ghcup.haskell.org | sh
  source ~/.ghcup/env
  log_done
  log_working "Installing cabal packages"
  cabal update
  cabal install cabal-fmt fast-tags
  log_done
  log_working "Installing hoogle and generating index"
  git clone https://github.com/ndmitchell/hoogle.git
  cd hoogle
  cabal install
  hoogle generate
  log_done
}

install_typst() {
  log_working "Installing typst"
  curl -Lo- https://github.com/typst/typst/releases/latest/download/typst-x86_64-unknown-linux-musl.tar.xz | tar -x --xz
  sudo mv typst*/typst /usr/local/bin/typst
  log_done

}

show_help() {
  cat << EOF
USAGE: $0 [-h] [INSTALL]...

If no INSTALL is specified then all will be run.
INSTALL can be any of:
  - packages    Install from package manager.
  - btop        Install btop.
  - debs        Install deb packages from github.
  - exercism    Install exercism CLI.
  - fish        Install fish-shell and plugins.
  - fzf         Install fzf a fuzzy finder.
  - go          Install Golang.
  - haskell     Install ghcup, haskell, haskell-language-server, stack and cabal
  - lazygit     Install lazygit a git client.
  - neovim      Install neovim and plugins.
  - node        Install Node & npm
  - ohmyposh    Install Oh-My-Posh a prompt theme manager.
  - pip         Install pip packages.
  - spotifytui  Install spotify-tui a spotify client.
  - typst       Install typst.

OPTIONS:
  -h, --help  Show this help message and exit.
EOF
}

main() {
  local validOptions=(
    packages
    btop
    debs
    exercism
    fish
    fzf
    go
    haskell
    lazygit
    neovim
    node
    ohmyposh
    pip
    spotifytui
    typst
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

  [[ -d "$BASH_COMP" ]] || mkdir -p "$BASH_COMP"

  for arg in "$@"; do
    (
      set -eo pipefail
      cd "$TMP"
      "install_$arg"
    )
    # shellcheck disable=2181
    [[ "$?" -eq 0 ]] || log_failed "install_$arg encountered an error"
  done
}

main "$@"
