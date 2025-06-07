#!/bin/bash

# Usage: ./toggle_sync.sh <style_off> <style_on>

style_off="$1"
style_on="$2"

# get current state
state=$(tmux show -v synchronize-panes)

# toggle it
if [ "$state" = "on" ]; then
	tmux setw synchronize-panes off
	tmux set -g status-style "$style_off"
else
	tmux setw synchronize-panes on
	tmux set -g status-style "$style_on"
fi
