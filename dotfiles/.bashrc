# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
  *i*) ;;
  *) return ;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
  debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
  xterm-color | *-256color) color_prompt=yes ;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
  if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
    # We have color support; assume it's compliant with Ecma-48
    # (ISO/IEC-6429). (Lack of such support is extremely rare, and such
    # a case would tend to support setf rather than setaf.)
    color_prompt=yes
  else
    color_prompt=
  fi
fi

if [ "$color_prompt" = yes ]; then
  PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
  PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
  xterm* | rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
  *) ;;

esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
  test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
  alias ls='ls --color=auto'
  #alias dir='dir --color=auto'
  #alias vdir='vdir --color=auto'

  alias grep='grep --color=auto'
  alias fgrep='fgrep --color=auto'
  alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
  . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

mesg n
shopt -s autocd

alias brc=". ~/.bashrc"
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

alias ...="../../"
alias ....="../../../"

export LESS=RF
# export CSSE2310_SVN="https://source.eait.uq.edu.au/svn/csse2310-sem1-s4717148/"

if [[ -n $SSH_CONNECTION ]]; then
  export CSSE2310=/local/courses/csse2310
  alias fzf="fzf --preview 'cat {}'"
else
  pgrep -u $USER ssh-agent &>/dev/null || eval "$(ssh-agent -s)" &>/dev/null
  export LS_COLORS=$LS_COLORS:'tw=01;34:ow=01;34:'
  alias fzf="fzf --preview 'bat --color=always --style=numbers --line-range=:500 {}'"
fi

if [[ -n $WSL_DISTRO_NAME ]]; then
  export WIN_USER="$(wslvar USERNAME)"
  export WIN_HOME=/mnt/c/Users/$WIN_USER
  export OD=$WIN_HOME/OneDrive
  export SEM=$OD/UNI/2022/sem-2
  # export PATH=$PATH:"/mnt/c/Users/${WIN_USER}/AppData/Local/Programs/Microsoft VS Code/bin:/mnt/c/Program Files/Git/cmd"
  alias yank='win32yank.exe -i'
  alias put='win32yank.exe -o'

  explorer() {
    local dest
    [[ -n "$1" ]] && dest=$(wslpath -w "$1") || dest="."
    /mnt/c/Windows/explorer.exe "$dest"
    return 0
  }
fi

if command -v pygmentize &>/dev/null; then
  alias pyg='pygmentize -g -P style=monokai'
  cless() {
    pygmentize -g -P style=monokai $1 | less
  }
fi

# Oh My Posh & Utility script.
if command -v oh-my-posh &>/dev/null; then
  export POSH_THEME=~/.poshthemes/min.omp.json
  eval "$(oh-my-posh init bash)"

  theme() {
    omputils theme "$@" && source ~/.bashrc
  }
fi

[[ -d /usr/local/go/bin ]] && export GOPATH=$HOME/go && export PATH=$PATH:/usr/local/go/bin:$GOPATH/bin
[[ -f ~/.config/exercism/exercism_completion.bash ]] && source ~/.config/exercism/exercism_completion.bash
[[ -f ~/.ghcup/env ]] && source ~/.ghcup/env
[[ -f /home/linuxbrew/.linuxbrew/bin/brew ]] && eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
[[ -f ~/.fzf.bash ]] && source ~/.fzf.bash

_pip_completion() {
  COMPREPLY=($(COMP_WORDS="${COMP_WORDS[*]}" \
    COMP_CWORD=$COMP_CWORD \
    PIP_AUTO_COMPLETE=1 $1 2>/dev/null))
}
complete -o default -F _pip_completion pip

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

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"                   # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # This loads nvm bash_completion
