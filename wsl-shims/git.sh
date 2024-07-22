#!/usr/bin/env bash

if [[ $PWD =~ /mnt/* ]]; then
  exec git.exe "$@"
else
  exec /usr/bin/git "$@"
fi
