# shellcheck shell=bash

# Check if an executable exists
# $1 - executable path
exists() {
  command -v "$1" &> /dev/null
}
