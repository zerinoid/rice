#!/usr/bin/env bash

# Checa se está na bateria
if [ -d /sys/class/power_supply/BAT0 ] && [ "$(cat /sys/class/power_supply/ADP0/online 2>/dev/null)" = "0" ]; then

  # NA BATERIA:
  exec xidlehook \
    --not-when-audio \
    --not-when-fullscreen \
    --timer 240 'xscreensaver-command -activate' '' \
    --timer 360 'slock' '' \
    --timer 1200 'systemctl suspend' ''

else

  # NA TOMADA (AC):
  exec xidlehook \
    --not-when-audio \
    --not-when-fullscreen \
    --timer 300 'xscreensaver-command -activate' '' \
    --timer 420 'slock' '' \
    --timer 3600 'systemctl suspend' ''

fi
