#!/usr/bin/env sh

# Ensure systemd user bus socket is picked up if available
if [ -z "$DBUS_SESSION_BUS_ADDRESS" ] && [ -n "$XDG_RUNTIME_DIR" ]; then
  export DBUS_SESSION_BUS_ADDRESS="unix:path=$XDG_RUNTIME_DIR/bus"
fi

. "$HOME/.xprofile"

# Export X variables to systemd and DBus environments dynamically
systemctl --user import-environment DISPLAY XAUTHORITY DBUS_SESSION_BUS_ADDRESS
dbus-update-activation-environment --systemd DISPLAY XAUTHORITY DBUS_SESSION_BUS_ADDRESS

exec bspwm
