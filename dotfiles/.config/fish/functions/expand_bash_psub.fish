function expand_bash_psub
    # commandline -f self-insert expand-abbr
    set -l cmd (commandline -b | sed -E 's/<\(([^\)]*)/(\1 | psub)/g;t;d')
    if set -q cmd[1]
        commandline --replace "$cmd"
    else
        commandline --insert ")"
    end
    commandline -f expand-abbr
end
