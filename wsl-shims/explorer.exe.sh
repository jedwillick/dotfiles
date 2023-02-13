#!/usr/bin/env bash

if [[ -z "$1" ]]; then
  dest="."
elif [[ "$1" =~ ^[a-z]+://.* ]]; then
  dest="$1"
else
  dest=$(wslpath -w "$1")
fi

exec "/mnt/c/Windows/explorer.exe" "$dest"
