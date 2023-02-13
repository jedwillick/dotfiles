fish_add_path -g ~/.local/bin
fish_add_path -g ~/bin
set -e XDG_RUNTIME_DIR


if not status is-interactive
    return
end

yes | fish_config theme save "Tomorrow Night Bright"
fish_default_key_bindings

# ls autoloads dircolors which other programs may need...
ls &>/dev/null

sabbr psu 'ps -u$USER'
sabbr psuf 'ps -fu$USER'
sabbr pgu 'pgrep -u$USER'
sabbr pku 'pkill -u$USER'

sabbr svn-ignore 'svn propedit svn:ignore .'
sabbr ldhere 'LD_LIBRARY_PATH=.:$LD_LIBRARY_PATH'

sabbr ll 'ls -lh'
sabbr la 'ls -lah'
sabbr lt 'tree -aI .git'
sabbr mkdir 'mkdir -p'

# valgrind
sabbr memcheck 'valgrind --leak-check=full --show-leak-kinds=all -s'
sabbr drd 'valgrind --tool=drd --first-race-only=yes --exclusive-threshold=15 -s'
sabbr helgrind 'valgrind --tool=helgrind -s'

abbr - 'cd -'

function _bash_psub
    # echo (string trim --chars='<()' $argv[1])
    echo YES
end

abbr -a bash_psub --position anywhere --regex '\<\(.+\)' --function _bash_psub

set -gx DOTFILES "$HOME/dotfiles"
set -gx GCC_COLORS 'error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'
set -gx WAKATIME_HOME "$HOME/.local/share/wakatime"

mesg n &>/dev/null || true

if type -q nvim
    set -gx EDITOR nvim
else
    set -gx EDITOR vim
end
set -gx VISUAL $EDITOR

if type -q oh-my-posh
    set -gx POSH_THEME '~/.local/share/poshthemes/basic.omp.json'
    oh-my-posh init fish | source
end

# Better CD
type -q zoxide && zoxide init fish | source

# Node
type -q fnm && fnm env --use-on-cd | source

fish_add_path -g /home/jed/.fzf/bin
set fzf_directory_opts --bind "ctrl-o:execute($EDITOR {} &> /dev/tty)"

# Haskel
fish_add_path -g ~/.cabal/bin
fish_add_path -g ~/.ghcup/bin

# Go
set -gx GOPATH ~/.local/go
fish_add_path -g /usr/local/go/bin
fish_add_path -g $GOPATH/bin
