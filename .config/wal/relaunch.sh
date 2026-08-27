#!/bin/sh

# Relaunch dunst in the background (avoid blocking)
pkill -x dunst
dunst &

# Relaunch polybar to update colors dynamically
#
[ "$(pidof polybar)" -gt 0 ] && "$HOME/.config/polybar/launch.sh" &
[ "$(pidof dwm)" -gt 0 ] && kill -HUP $(pidof dwm) &

# Update emacs theme
# emacsclient -s "$EMACS_SERVER_SOCKET" -e "(load-theme 'ewal-spacemacs-modern t)"
