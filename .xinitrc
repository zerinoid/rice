#!/usr/bin/env sh

eval $(dbus-launch --sh-syntax --exit-with-x11)

. "$HOME/.xprofile"

exec bspwm
