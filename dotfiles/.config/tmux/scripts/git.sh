#!/usr/bin/env bash
# shellcheck disable=2034

_git() {
  git --no-optional-locks -c color.status=false "$@" 2> /dev/null
}

addChanges() {
  case "$1" in
    .) ;;
    D) ((deleted++)) ;;
    A) ((added++)) ;;
    U) ((unmerged++)) ;;
    M | R | C | T) ((modified++)) ;;
  esac
}

ifChange() {
  if [[ -n "$1" && "$1" != "0" ]]; then
    echo -n " $1$2"
  fi
}

ifValue() {
  if [[ -n "$1" && "$1" != "0" ]]; then
    echo -n "$1$2"
  fi
}

statusChanges() {
  printf "%s%s%s%s%s" \
    "$(ifChange "${untracked}" "?")" \
    "$(ifChange "${added}" "A")" \
    "$(ifChange "${modified}" "M")" \
    "$(ifChange "${deleted}" "D")" \
    "$(ifChange "${unmerged}" "U")"
}

remoteChanges() {
  if [[ -z "$upstream" ]]; then
    printf "[≢]"
  elif [[ "$behind" != "0" || "$ahead" != "0" ]]; then
    printf "[%s%s]" "$(ifValue "$ahead" "↑")" "$(ifValue "$behind" "↓")"
  fi
}

printBranch() {
  if [[ "$branch" == "(detached)" ]]; then
    printf "detached"
    tag="$(_git describe --tags --exact-match 2> /dev/null)"
    if [[ -n "$tag" ]]; then
      printf "(%s)" "$tag"
    fi
  else
    printf "%s" "$branch"
  fi
}

dir=$(tmux display -p '#{pane_current_path}')
cd "$dir" || exit

status=$(_git status --untracked-files=all --porcelain=2 --branch) || exit 0

branchPrefix="# branch.head "
upstreamPrefix="# branch.upstream "
abPrefix="# branch.ab "

while IFS= read -r line; do
  case "$line" in
    ${branchPrefix}*)
      branch=${line#"${branchPrefix}"}
      ;;
    ${upstreamPrefix}*)
      upstream=${line#"${upstreamPrefix}"}
      ;;
    ${abPrefix}*)
      ab=${line#"${abPrefix}"}
      #+0 -0
      ahead=${ab:1:1}
      behind=${ab:4:1}
      ;;
    \?*)
      ((untracked++))
      ;;
    \#*) ;;
    *)
      addChanges "${line:2:1}"
      addChanges "${line:3:1}"
      ;;
  esac
done <<< "$status"

printf " %s%s%s" \
  "$(printBranch)" \
  "$(remoteChanges)" \
  "$(statusChanges)"
