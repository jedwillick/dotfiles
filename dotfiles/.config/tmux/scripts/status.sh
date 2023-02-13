#!/usr/bin/env bash
# shellcheck disable=2034

# Dracula Color Pallette
white='#f8f8f2'
gray='#44475a' #'#1f2335'
dark_gray='#282a36'
light_purple='#bd93f9'
dark_purple='#6272a4'
cyan='#8be9fd'
green='#50fa7b'
orange='#ffb86c'
red='#ff5555'
pink='#ff79c6'
yellow='#f1fa8c'

left_sep=""
right_sep=""

interval=5

prefix_left="#[bg=${green},fg=${dark_gray}]#{?client_prefix,#[bg=${yellow}],}"
prefix_right="#[fg=${green},bg=${gray}]#{?client_prefix,#[fg=${yellow}],}${left_sep}"
prefix_icon=" #S " # Session name

flags="#{?window_flags,#[fg=${dark_purple}]#{window_flags},}"
current_flags="#{?window_flags,#[fg=${light_purple}]#{window_flags},}"

win_active_left="#[fg=${gray},bg=${dark_purple}]${left_sep}#[fg=${white},bg=${dark_purple}]"
win_active_right="#[fg=${dark_purple},bg=${gray}]${left_sep}"
win_active=" #I #W#{?#{m/r:n?vim,#W},:#{b:pane_current_path},}${current_flags} "

win_inactive_left="#[fg=${white}]#[bg=${gray}]"
win_inactive_right=""
win_inactive=" #I #W#{?#{m/r:n?vim,#W},:#{b:pane_current_path},}${flags} "

tmux set-option -g automatic-rename on

tmux set-option -g status-interval "${interval}"

# Clock prefix + t
tmux set-option -g clock-mode-style 24
tmux setw -g clock-mode-colour "${orange}"

tmux set-option -g pane-border-style "fg=${gray}"
tmux set-option -g pane-active-border-style "fg=${light_purple}"
tmux set-option -g message-style "bg=${gray},fg=${white}"
tmux set-option -g status-style "bg=${gray},fg=${white}"

tmux set-window-option -g window-status-current-format "${win_active_left}${win_active}${win_active_right}"
tmux set-window-option -g window-status-format "${win_inactive_left}${win_inactive}${win_inactive_right}"
tmux set-window-option -g window-status-activity-style "bold"
tmux set-window-option -g window-status-bell-style "bold"

tmux set-option -g status-left-length 100
tmux set-option -g status-right-length 200
tmux set -g status-justify left

tmux set-option -g status-left "${prefix_left}${prefix_icon}${prefix_right}"

tmux set -g status-right "#[fg=${gray},bg=${gray},nobold,nounderscore,noitalics]${right_sep}#[fg=${green},bg=${gray}] #(exec ${TMUX_CONFIG_PATH}/scripts/spotify.sh) "
tmux set -ga status-right "#[fg=${green},bg=${gray},nobold,nounderscore,noitalics]${right_sep}#[fg=${dark_gray},bg=${green}]#(exec ${TMUX_CONFIG_PATH}/scripts/git.sh) "
tmux set -ga status-right "#[fg=${orange},bg=${green}]${right_sep}#[fg=${dark_gray},bg=${orange}] {#(exec wakatime-cli --today)}"
tmux set -ga status-right "#[push-default]#(exec ${TMUX_PLUGIN_MANAGER_PATH}/tmux-mem-cpu-load/tmux-mem-cpu-load --powerline-right --interval ${interval} --graph-lines 4) "
