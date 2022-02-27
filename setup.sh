#!/usr/bin/env bash

bak=backup/$(date '+%d-%m-%Y_%H.%M.%S')
mkdir -p $bak

for file in dotfiles/.*[^.]; do
    base=$(basename $file)
    if [[ -d $file ]]; then
        for sub in ${file}/*; do
            link=~/${sub#dotfiles/}
            mkdir -p $bak/$base && cp $link $_ 2>/dev/null | true
            ln -sf $(pwd)/$sub $link
        done
    elif [[ -f $file ]]; then
        cp ~/$base $bak/$base 2>/dev/null | true
        ln -sf $(pwd)/$file ~/$base
    fi
done

