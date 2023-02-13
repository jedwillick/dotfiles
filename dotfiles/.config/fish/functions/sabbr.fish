function __sudo_abbr
    string match --quiet "sudo *" -- (commandline -j) || return 1
    abbr --show | grep -w $argv[1] | read --tokenize --array cmd || return 1
    echo $cmd[-1]
end

function sabbr -d "Add an abbreviation and also one for sudo"
    abbr $argv
    abbr -a "sudo_$argv[1]" --position anywhere --regex $argv[1] --function __sudo_abbr
end
