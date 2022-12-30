#!/usr/bin/env bash

extract() {
  case $1 in
    *.tar)
      tar -xf "$1"
      ;;
    *.tar.gz)
      tar -xzf "$1"
      ;;
    *.zip)
      unzip "$1"
      ;;
    *)
      echo "Unknown $1"
      ;;
  esac
}

extract "$@"
