#!/usr/bin/env bash

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
  stow $d
done
