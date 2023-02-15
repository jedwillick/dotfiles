#!/usr/bin/env bash

readonly PROG="${0##*/}"
declare VERBOSE=false
declare LIST=false

# $1 - extract
# $2 - list
# $3 - verbose
getOptions() {
  local opts=()
  if $LIST; then
    opts+=("$2")
  else # Extract
    opts+=("$1")
  fi

  if $VERBOSE; then
    opts+=("$3")
  fi
  printf "%s" "${opts[*]}"
}

_tar() {
  read -ra opts < <(getOptions "-x" "-t" "")
  opts+=("-af")
  tar "${opts[@]}" "$1"
}

_unzip() {
  read -ra opts < <(getOptions "" "-l" "-v")
  unzip "${opts[@]}" "$1"
}

_gunzip() {
  read -ra opts < <(getOptions "" "-l" "-v")
  gunzip "${opts[@]}" "$1"
}

_7z() {
  read -ra opts < <(getOptions "x" "l" "")
  7z "${opts[@]}" "$1"
}

_appimage() {
  if $LIST; then
    echo "AppImage does not support listing files." >&2
    return 1
  fi
  chmod +x "$1" && "./$1" --appimage-extract
}

_rar() {
  read -ra opts < <(getOptions "x" "l" "")
  if command -v rar &> /dev/null; then
    rar "${opts[@]}" "$1"
  elif command -v unrar &> /dev/null; then
    unrar "${opts[@]}" "$1"
  else
    echo "No supported RAR program found." >&2
    return 1
  fi
}

_dpkg-deb() {
  read -ra opts < <(getOptions "-x" "-c" "-v")
  opts+=("$1")
  if ! $LIST; then
    opts+=(".")
  fi
  dpkg-deb "${opts[@]}"
}

_xz() {
  read -ra opts < <(getOptions "-d" "-l" "")
  xz "${opts[@]}" "$1"
}

_bzip2() {
  read -ra opts < <(getOptions "-d" "-tvv" "-v")
  bzip2 "${opts[@]}" "$1"
}

extract() {
  for archive in "$@"; do
    case $archive in
      *.tar | *.tar.*)
        _tar "$archive"
        ;;
      *.zip)
        _unzip "$archive"
        ;;
      *.gz | *-gz | *.z | *-z | *_z | *.Z | *.tgz | *.taz)
        _gunzip "$archive"
        ;;
      *.7z)
        _7z "$archive"
        ;;
      *.appimage | *.AppImage)
        _appimage "$archive"
        ;;
      *.rar)
        _rar "$archive"
        ;;
      *.deb)
        _dpkg-deb "$archive"
        ;;
      *.xz | *.lzma | *.txz | *.tlz)
        _xz "$archive"
        ;;
      *.bz | *.bz2 | *.tbz | *.tbz2)
        _bzip2 "$archive"
        ;;
      *)
        echo "Unknown extension $archive" >&2
        ;;
    esac
  done
}

show_help() {
  cat << EOF
USAGE: $PROG [OPTIONS]... ARCHIVES...

Extract various compressed files/archives.
Currently supported programs are tar, gunzip, unzip, 7z,
rar, xz, bzip2, appimage, dpkg-deb.

OPTIONS:
  -h, --help      Show this help message and exit.
  -d, --debug     Enable debug mode.
  -l, --list      List the contents of the archive instead of extracting it.

EOF
}

main() {
  options=$(getopt -n "$PROG" -l "help,debug,verbose,list" -o "hdvl" -- "$@") || exit 1

  eval set -- "$options"
  while true; do
    case "$1" in
      -h | --help)
        show_help
        return 0
        ;;
      -d | --debug)
        set -x
        ;;
      -v | --verbose)
        VERBOSE=true
        ;;
      -l | --list)
        LIST=true
        ;;
      --)
        shift
        break
        ;;
    esac
    shift
  done

  readonly VERBOSE
  readonly LIST

  if [[ $# -eq 0 ]]; then
    echo "No archives provided." >&2
    show_help
    return 1
  fi
  extract "$@"
}

main "$@"
