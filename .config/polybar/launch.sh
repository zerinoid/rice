#!/bin/bash

LOG_DIR="/tmp/polybar-logs"
TIMESTAMP=$(date +%Y-%m-%d %H:%M:%S)
LOG_FILE="$LOG_DIR/polybar-$(date +%Y%m%d).log"

# Create log directory if it doesn't exist
mkdir -p "$LOG_DIR"

# Function to log messages with timestamp
log_message() {
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >>"$LOG_FILE"
}

# Kill any existing polybar instances
log_message "Stopping existing polybar instances..."
killall -s SIGKILL polybar

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do
  sleep 1
done

log_message "All polybar instances stopped"

# Dynamically detect hardware interfaces for portability
log_message "Detecting hardware interfaces..."

# 1. Backlight card
export BACKLIGHT_CARD=$(ls -1 /sys/class/backlight/ | head -n1)
if [ -n "$BACKLIGHT_CARD" ]; then
  log_message "Detected backlight card: $BACKLIGHT_CARD"
else
  log_message "No backlight card detected"
fi

# 2. Battery & AC Adapter
export BATTERY=$(basename $(find /sys/class/power_supply -name "BAT*" -o -name "BATT*" | head -n1) 2>/dev/null)
export ADAPTER=$(basename $(find /sys/class/power_supply -name "AC*" -o -name "ADP*" -o -name "ACAD*" | head -n1) 2>/dev/null)
[ -n "$BATTERY" ] && log_message "Detected battery: $BATTERY"
[ -n "$ADAPTER" ] && log_message "Detected AC adapter: $ADAPTER"

# 3. Wireless interface
WIRELESS_INTERFACE=""
for dev in /sys/class/net/*; do
  if [ -d "$dev/wireless" ] || [ -d "$dev/phy80211" ]; then
    WIRELESS_INTERFACE=$(basename "$dev")
    break
  fi
done
if [ -z "$WIRELESS_INTERFACE" ]; then
  WIRELESS_INTERFACE=$(ip link | awk -F': ' '/wlp|wlan/ {print $2}' | head -n1)
fi
export WIRELESS_INTERFACE="${WIRELESS_INTERFACE:-wlan0}"
log_message "Using wireless interface: $WIRELESS_INTERFACE"

# Launch polybar based on available monitors
if type "xrandr" >/dev/null 2>&1; then
  log_message "Detecting monitors using xrandr..."

  # Find primary monitor
  primary_mon=$(xrandr --query | grep "primary" | cut -d" " -f1)
  [ -z "$primary_mon" ] && primary_mon=$(xrandr --query | grep " connected" | cut -d" " -f1 | head -n1)

  for m in $(xrandr --query | grep " connected" | cut -d" " -f1); do
    if [ "$m" = "$primary_mon" ]; then
      log_message "Launching primary polybar on monitor: $m"
      MONITOR=$m polybar --reload primary 2>&1 | while read -r line; do
        echo "[$(date '+%Y-%m-%d %H:%M:%S')] $line" >>"$LOG_FILE"
      done &
    else
      log_message "Launching secondary polybar on monitor: $m"
      MONITOR=$m polybar --reload secondary 2>&1 | while read -r line; do
        echo "[$(date '+%Y-%m-%d %H:%M:%S')] $line" >>"$LOG_FILE"
      done &
    fi
  done
else
  log_message "xrandr not found, launching single primary polybar instance"
  polybar --reload primary 2>&1 | while read -r line; do
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $line" >>"$LOG_FILE"
  done &
fi

log_message "Polybar launch process completed"
echo "Polybar logs available at: $LOG_FILE"
