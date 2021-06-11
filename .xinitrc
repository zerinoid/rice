#!/usr/bin/env sh

eval $(dbus-launch --sh-syntax --exit-with-x11)

. "$HOME/.xprofile"

systemctl --user set-environment DISPLAY=:0

exec bspwm

