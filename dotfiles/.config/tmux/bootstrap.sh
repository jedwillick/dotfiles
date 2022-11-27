#!/usr/bin/env bash

if [[ ! -d "$TMUX_PLUGIN_MANAGER_PATH/tpm" ]]; then
  git clone https://github.com/tmux-plugins/tpm "$TMUX_PLUGIN_MANAGER_PATH/tpm"
  tmux source "$TMUX_CONFIG_PATH/tmux.conf"
fi
