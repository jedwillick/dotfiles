# shellcheck shell=bash

# If not running interactively, don't do anything
case $- in
  *i*) ;;
  *) return ;;
esac

HISTCONTROL=ignoreboth
HISTSIZE=1000
HISTFILESIZE=2000

shopt -s checkwinsize
shopt -s histappend
shopt -s autocd

# make less more friendly for non-text input files, see lesspipe(1)
[[ -x /usr/bin/lesspipe ]] && eval "$(SHELL=/bin/sh lesspipe)"

# enable programmable completion features
if ! shopt -oq posix; then
  if [[ -f /usr/share/bash-completion/bash_completion ]]; then
    source /usr/share/bash-completion/bash_completion
  elif [[ -f /etc/bash_completion ]]; then
    source /etc/bash_completion
  fi
fi

[[ -f ~/.bash_aliases ]] && source ~/.bash_aliases

if [[ -x /usr/bin/dircolors ]]; then
  if [[ -r ~/.dircolors ]]; then
    eval "$(dircolors -b ~/.dircolors)"
  else
    eval "$(dircolors -b)"
  fi
  alias ls='ls --color=auto'
  alias dir='dir --color=auto'
  alias vdir='vdir --color=auto'

  alias grep='grep --color=auto'
  alias fgrep='fgrep --color=auto'
  alias egrep='egrep --color=auto'
fi

alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

alias brc='source ~/.bashrc'
alias sudo='sudo '
alias psu='ps -u $USER'
alias pgu='pgrep -u $USER'
alias pku='pkill -u $USER'
alias svn-ignore='svn propedit svn:ignore .'
alias diff='diff --color=auto'

# valgrind
alias memcheck='valgrind --leak-check=full --show-leak-kinds=all -s'
alias drd='valgrind --tool=drd --first-race-only=yes --exclusive-threshold=15 -s'
alias helgrind='valgrind --tool=helgrind -s'

alias ...='cd ../../'
alias ....='cd ../../../'

export LESS=RF
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'
export WAKATIME_HOME="$HOME/.local/share/wakatime"
export DOTFILES="$HOME/dotfiles"

if [[ -n $SSH_CONNECTION ]]; then
  mesg n &> /dev/null || true
  export CSSE2310=/local/courses/csse2310
else
  pgrep -u "$USER" ssh-agent &> /dev/null || eval "$(ssh-agent -s)" &> /dev/null
  export LS_COLORS=$LS_COLORS:'tw=01;34:ow=01;34:'
fi

if [[ -n $WSL_DISTRO_NAME ]]; then
  WIN_USER=$(/mnt/c/Windows/System32/cmd.exe /c 'echo %USERNAME%' 2> /dev/null | tr -d '\r\n')
  export WIN_USER
  export WIN_HOME=/mnt/c/Users/$WIN_USER
  export OD=$WIN_HOME/OneDrive
  export SEM=$OD/UNI/2022/sem-2
  alias yank='win32yank.exe -i'
  alias put='win32yank.exe -o'

  explorer() {
    local dest
    [[ -n "$1" ]] && dest=$(wslpath -w "$1") || dest="."
    /mnt/c/Windows/explorer.exe "$dest"
    return 0
  }
fi

source ~/.local/share/util.sh

if exists bat; then
  alias fzf="fzf --preview 'bat --color=always --style=numbers --line-range=:500 {}'"
else
  alias fzf="fzf --preview 'cat {}'"
fi

if exists pygmentize; then
  alias pyg='pygmentize -g -P style=monokai'
  cless() {
    pygmentize -g -P style=monokai "$1" | less
  }
fi

if exists nvim; then
  # Ensure cusor is restored to blinking line
  export PROMPT_COMMAND="printf '\e[5 q'"
  export EDITOR=nvim
else
  export EDITOR=vim
fi
export VISUAL=$EDITOR

# Oh My Posh Prompt
if exists oh-my-posh; then
  export POSH_THEME=~/.local/share/poshthemes/basic.omp.json
  eval "$(oh-my-posh init bash)"

  theme() {
    omputils theme "$@" && source ~/.bashrc
  }
else
  # Set default prompt https://www.gnu.org/software/bash/manual/html_node/Controlling-the-Prompt.html
  # Set title: shell :: folder
  PS1="\[\e]0;\s :: \W\a\]"
  # Set prompt: user@host:dir
  PS1="$PS1\[\e[01;32m\]\u@\h\[\e[00m\]:\[\e[01;34m\]\w\[\e[00m\]\$ "
fi

[[ -d /usr/local/go/bin ]] && export GOPATH=~/.local/go && export PATH=$PATH:/usr/local/go/bin:$GOPATH/bin
[[ -f ~/.config/exercism/exercism_completion.bash ]] && source ~/.config/exercism/exercism_completion.bash
[[ -f ~/.ghcup/env ]] && source ~/.ghcup/env
[ -f "${XDG_CONFIG_HOME:-$HOME/.config}"/fzf/fzf.bash ] && source "${XDG_CONFIG_HOME:-$HOME/.config}"/fzf/fzf.bash

_fzf_comprun() {
  local command=$1
  shift

  case "$command" in
    cd) fzf "$@" --preview 'tree -C {} | head -200' ;;
    export | unset) fzf "$@" --preview "eval 'echo \$'{}" ;;
    ssh) fzf "$@" --preview 'dig {}' ;;
    *) fzf "$@" ;;
  esac
}

if [[ -d "$HOME/.nvm" ]]; then
  export NVM_DIR="$HOME/.nvm"
  [[ -s "$NVM_DIR/nvm.sh" ]] && source "$NVM_DIR/nvm.sh"                   # This loads nvm
  [[ -s "$NVM_DIR/bash_completion" ]] && source "$NVM_DIR/bash_completion" # This loads nvm bash_completion
fi
