#!/usr/bin/env bash

source ~/.local/share/util.sh

readonly PROG="${0##*/}"

# Temp directory that will be populated after arguments have been parsed.
# And be automatically deleted upon exit.
declare TMP

error() {
  printf "[ \x1b[1;31mERROR\x1b[0m ] %s\n" "$1" >&2
}

warn() {
  printf "[ \x1b[33mWARN\x1b[0m  ] %s\n" "$1" >&2
}

printrepo() {
  printf "%s@%s" "$1" "$(basename "$2")"
}

# Make a request to Github's API
# $1 - Request
query_github() {
  if exists gh; then
    gh api "/$1"
  else
    if [[ -z "$GITHUB_TOKEN" ]]; then
      curl --silent "https://api.github.com/$1"
    else
      curl --silent -H "Authorization: Bearer $GITHUB_TOKEN" "https://api.github.com/$1"
    fi
  fi
}

# Install a deb package from a Github repo.
# $1 - Response from Github API
# $2 - Repo name
# $3 - Tag
install_deb_from_github() {
  local arch
  arch=$(dpkg --print-architecture)
  local url
  url=$(jq -r ".. .browser_download_url? // empty | select(contains(\"$arch\") and endswith(\"deb\") and (contains(\"musl\") | not ))" <<< "$1")

  if [[ -z "$url" ]]; then
    return 1
  fi

  local dest
  dest="$TMP/$(basename "$url")"
  curl -Lo "$dest" "$url"
  sudo apt -q=3 install "$dest"
}

# Install a binary from a Github repo into $HOME/.local/bin.
# $1 - Response from Github API
# $2 - Repo name
# $3 - Tag
# $4 - name (defaults to repo name)
install_binary_from_github() {
  local arch url
  # arch=$(dpkg --print-architecture)
  url=$(jq -r ".. .browser_download_url? // empty | select(contains(\"x86_64\") and contains(\"linux\") and ((contains(\"musl\") or test(\"\\\.[a-zA-Z0-9]+\$\"))  | not ))" <<< "$1")

  if [[ -z "$url" ]]; then
    return 1
  fi

  local name="${4:-$(basename "$2")}"
  local dest="$HOME/.local/bin/$name"
  local tmpDest="$TMP/$name"

  curl -Lo "$tmpDest" "$url"
  chmod +x "$tmpDest"
  mv "$tmpDest" "$dest"
}

# Install a release from a Github Repo
# $1 - Repo name
# $2 - Tag
# $3 - out
# $4 - source
install_from_github() {
  local response
  response=$(query_github "repos/$1/releases/$2")
  case "$response" in
    *"Not Found"*)
      error "Release not found for $(printrepo "$1" "$2")"
      return 1
      ;;
    *"limit exceeded"*)
      error "Rate limit exceeded. Try again later."
      query_github "rate_limit" | jq ".resources.core"
      return 1
      ;;
    *"Bad credentials"*)
      error "Bad credentials. Ensure GITHUB_TOKEN is set appropriately."
      return 1
      ;;
  esac

  TMP=$(mktemp -d)
  readonly TMP
  chmod 777 "$TMP"
  trap 'rm -rf "$TMP"' EXIT
  (
    set -e
    case "$source" in
      auto)
        install_binary_from_github "$response" "$@" || install_deb_from_github "$response" "$@"
        ;;
      binary)
        install_binary_from_github "$response" "$@"
        ;;
      deb)
        install_deb_from_github "$response" "$@"
        ;;
    esac
  )
  # shellcheck disable=2181
  [[ "$?" -eq 0 ]] || error "Failed to install $4 from $(printrepo "$1" "$2")"
}

show_help() {
  cat << EOF
USAGE: $PROG [OPTIONS].. REPO

Install github releases with the user/repo syntax.

OPTIONS:
  -h, --help        Show this help message and exit.
  -s, --source SRC  Specify the release source. Can be one of 'deb', 'binary', or 'auto'.
  -t, --tag TAG     Specify the release tag.
  -n, --name        Specify a different file name (only relevant for bianries).
  -d, --debug       Enable debug mode.

Dependancies:
  - jq           For parsing JSON responses
  - gh or curl   For making requests to Github's API
EOF
}

main() {
  local source="auto"
  local tag="latest"
  local name=""

  options=$(getopt -n "$PROG" -l "help,debug,source:,tag:,name:" -o "hds:t:n:" -- "$@") || exit 1

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
      -s | --source)
        shift
        source="$1"
        ;;
      -t | --tag)
        shift
        tag="$1"
        [[ $tag != "latest" ]] && tag="tags/$tag"
        ;;
      -n | --name)
        shift
        name="$1"
        ;;
      --)
        shift
        break
        ;;
    esac
    shift
  done

  if [[ $# -eq 0 ]]; then
    error "Missing repo."
    return 1
  fi

  if [[ $# -ne 1 ]]; then
    error "Too many arguments."
    return 1
  fi
  local repo="$1"
  # All arguments accounted for

  case "$source" in
    auto | binary | deb)
      install_from_github "$repo" "$tag" "$name" "$source"
      ;;
    *)
      error "Invalid source: $source"
      return 1
      ;;
  esac
}

main "$@"
