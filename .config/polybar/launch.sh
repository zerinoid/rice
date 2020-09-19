#!/usr/bin/env bash

# Terminate already running bar instances
killall -q polybar

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

# Launch bar1 and bar2
bar1=main
bar2=extra
echo "---" | tee -a /tmp/$bar1.log /tmp/$bar2.log

#for m in $(polybar --list-monitors | cut -d":" -f1); do
#    MONITOR=$m polybar --reload $bar1 >>/tmp/$bar1.log 2>&1 &
#done

MONITOR="eDP1" polybar --reload $bar1 -c ~/.config/polybar/config.ini >>/tmp/$bar1.log 2>&1 &

externo=$(xrandr --query | grep "HDMI1")
if [[ ! $externo = *disconnected* ]]; then
  MONITOR="HDMI1" polybar --reload $bar2 -c ~/.config/polybar/config.ini >>/tmp/$bar2.log 2>&1 &
fi

echo "Bars launched..."
