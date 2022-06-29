#!/usr/bin/env bash

command -v stow &>/dev/null || (echo "Stow not installed" && exit 1)

IGNORE=(
  "backup/"
  "powershell/"
  "fonts/"
  "dotfiles/"
)

for d in */; do
  if [[ " ${IGNORE[*]} " =~ " ${d} " ]]; then
    continue
  fi
  stow -v $d
done
