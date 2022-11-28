#!/usr/bin/env bash

if [[ ! -d "$TMUX_PLUGIN_MANAGER_PATH/tpm" ]]; then
  git clone https://github.com/tmux-plugins/tpm "$TMUX_PLUGIN_MANAGER_PATH/tpm"
  "$TMUX_PLUGIN_MANAGER_PATH"/tpm/bin/install_plugins
fi
