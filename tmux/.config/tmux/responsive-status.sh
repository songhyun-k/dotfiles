#!/usr/bin/env bash
# Responsive tmux status bar layout
# Wide (>= 120): 1 line - left | center windows | right system info
# Narrow (< 120): 2 lines - left + windows right | system info on line 2

THRESHOLD=120
WIDTH=$(tmux display -p '#{client_width}' 2>/dev/null || echo 200)

if [ "$WIDTH" -ge "$THRESHOLD" ]; then
    tmux set -g status on
    tmux set -g status-justify "absolute-centre"
    tmux set -g status-right '#(~/.config/tmux/status-right.sh)'
else
    tmux set -g status 2
    tmux set -g status-justify "right"
    tmux set -g status-right ""
    tmux set -g 'status-format[1]' '#[align=right bg=default]#(~/.config/tmux/status-right.sh)'
fi
