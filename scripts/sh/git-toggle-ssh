#!/usr/bin/env bash

# Toggle the github remote between SSH and HTTPS
# $1 - remote name (optional, defaults to origin)
git_toggle_ssh() {
  local remote url
  remote="${1:-origin}"
  url=$(git config --get remote."$remote".url)
  if [[ -z $url ]]; then
    echo "Remote '$remote' not found"
    return 1
  elif [[ $url != *github* ]]; then
    echo "Must be inside a github repo"
    return 1
  fi

  if [[ $url == git@* ]]; then
    url=${url/git@github.com:/https:\/\/github.com\/}
    echo "Using HTTPS"
  else
    url=${url/https:\/\/github.com\//git@github.com:}
    echo "Using SSH"
  fi
  git remote set-url "$remote" "$url"
  git remote -v | grep "$remote"
}

git_toggle_ssh "$@"
