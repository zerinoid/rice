#!/bin/bash

# Polybar Launcher with Error Logging
# Save as: ~/bin/launch-polybar.sh

LOG_DIR="/tmp/polybar-logs"
LOG_FILE="$LOG_DIR/polybar-$(date +%Y%m%d).log"

# Create log directory if it doesn't exist
mkdir -p "$LOG_DIR"

# Kill any existing polybar instances
killall -q polybar

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

# Launch polybar and log errors with timestamp
echo "=== Polybar Launch - $(date) ===" >> "$LOG_FILE"
polybar main 2>&1 | while read -r line; do
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $line" >> "$LOG_FILE"
done &
