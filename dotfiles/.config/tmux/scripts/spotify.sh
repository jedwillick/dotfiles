#!/usr/bin/env bash

# https://stackoverflow.com/a/3352015
trim() {
  local var="$*"
  # remove leading whitespace characters
  var="${var#"${var%%[![:space:]]*}"}"
  # remove trailing whitespace characters
  var="${var%"${var##*[![:space:]]}"}"
  printf '%s' "$var"
}

if ! command -v spt &> /dev/null; then
  exit 1
fi

raw=$(spt playback --format "%s %t;%a")

[ -z "$raw" ] && exit

title=$(trim "$(echo "$raw" | cut -d';' -f1 | cut -d'-' -f1)")
artist=$(trim "$(echo "$raw" | cut -d';' -f2 | cut -d',' -f1)")
full="$title - $artist"
echo "${full}"
