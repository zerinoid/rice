#!/bin/sh

# Relaunch dunst in the background (avoid blocking)
pkill -x dunst
dunst &

# Relaunch polybar to update colors dynamically
"$HOME/.config/polybar/launch.sh" &

# Update emacs theme
emacsclient -s "$EMACS_SERVER_SOCKET" -e "(load-theme 'ewal-spacemacs-modern t)"
