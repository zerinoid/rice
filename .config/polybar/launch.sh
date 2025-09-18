#!/bin/bash

LOG_DIR="/tmp/polybar-logs"
TIMESTAMP=$(date +%Y-%m-%d %H:%M:%S)
LOG_FILE="$LOG_DIR/polybar-$(date +%Y%m%d).log"

# Create log directory if it doesn't exist
mkdir -p "$LOG_DIR"

# Function to log messages with timestamp
log_message() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> "$LOG_FILE"
}

# Kill any existing polybar instances
log_message "Stopping existing polybar instances..."
killall -q polybar

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do
    sleep 1
done

log_message "All polybar instances stopped"

# Launch polybar based on available monitors
if type "xrandr" >/dev/null 2>&1; then
    log_message "Detecting monitors using xrandr..."
    
    for m in $(xrandr --query | grep " connected" | cut -d" " -f1); do
        log_message "Launching polybar on monitor: $m"
        MONITOR=$m polybar --reload $m 2>&1 | while read -r line; do
            echo "[$(date '+%Y-%m-%d %H:%M:%S')] $line" >> "$LOG_FILE"
        done &
    done
else
    log_message "xrandr not found, launching single polybar instance"
    polybar --reload $m 2>&1 | while read -r line; do
        echo "[$(date '+%Y-%m-%d %H:%M:%S')] $line" >> "$LOG_FILE"
    done &
fi

log_message "Polybar launch process completed"
echo "Polybar logs available at: $LOG_FILE"
