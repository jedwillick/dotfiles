if not status is-interactive || not set -q WSL_DISTRO_NAME
    return
end

set -gx WIN_USER $(/mnt/c/Windows/System32/cmd.exe /c 'echo %USERNAME%' 2> /dev/null | tr -d '\r\n')
set -gx WIN_HOME /mnt/c/Users/$WIN_USER
set -gx OD $WIN_HOME/OneDrive
set -gx SEM $OD/UNI/2022/sem-2

set -gx BROWSER explorer.exe

sabbr yank 'win32yank.exe -i'
sabbr put 'win32yank.exe -o'
