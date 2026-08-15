#!/usr/bin/env bash
set -euo pipefail

sleep 5

# Visual output
export DISPLAY="${DISPLAY:-:0}"
export XAUTHORITY="${XAUTHORITY:-$HOME/.Xauthority}"
export DBUS_SESSION_BUS_ADDRESS="${DBUS_SESSION_BUS_ADDRESS:-unix:path=/run/user/$(id -u)/bus}"

# Open Alacritty and tail logs, keeping it open until Enter is pressed
alacritty -e bash -c "journalctl --user -fu sys-bkp -n 30; echo 'Backup process finished. Press Enter to close...'; read -r" &

MOUNTPOINT=/mnt/backup
TARGET=$MOUNTPOINT/borg-backups/saturno2024.borg
DATE=$(date --iso-8601)-$(hostname)

BACKUPCFG="$HOME/.local/share/backups"
DISKS="$BACKUPCFG/backup.disks"

uuid=""
for u in $(lsblk --noheadings --list --output uuid); do
  if grep --quiet --fixed-strings "$u" "$DISKS"; then
    uuid="$u"
    break
  fi
done

if [ -z "$uuid" ]; then
  echo "No backup disk found, exiting"
  exit 0
fi

echo "Disk $uuid is a backup disk"
partition_path="/dev/disk/by-uuid/$uuid"

(sudo mount | grep -q "$MOUNTPOINT") || sudo mount "$partition_path" "$MOUNTPOINT"
drive=$(lsblk --inverse --noheadings --list --paths --output name "$partition_path" | head -n 1)
echo "Drive path: $drive"

# CRITICAL FIX 1: Array representation avoids globbing/splitting errors
BORG_OPTS=(
  --stats
  --list
  --one-file-system
  --compression zstd,3
  --checkpoint-interval 86400
  --exclude-from "$BACKUPCFG/exclude"
)

export BORG_RELOCATED_REPO_ACCESS_IS_OK=no
export BORG_UNKNOWN_UNENCRYPTED_REPO_ACCESS_IS_OK=no

borg --version

echo "Starting backup for $DATE"
shopt -s globstar

# CRITICAL FIX 2: Track cumulative failures across all sub-backups
overall_status=0

run_backup() {
  local archive_suffix="$1"
  shift
  borg create "${BORG_OPTS[@]}" "$TARGET::$DATE-$$-${archive_suffix}" "$@" || {
    echo "Error backing up section: ${archive_suffix}" >&2
    overall_status=1
  }
}

run_backup "db" "$HOME/db" "$HOME/docs"
run_backup "pessoais" "$HOME/pics" "$HOME/videos"
run_backup "sistema" "$HOME/.ssh" "$HOME/.env" "$HOME/.histdb"
run_backup "musica" "$HOME/music"
run_backup "lenny" "$HOME/.ban" "$HOME/db" "$HOME/tmp/mac"

# PRACTICE 3: Added Pruning & Compacting
echo "Pruning older backups..."
borg prune \
  --list \
  --keep-daily 7 \
  --keep-weekly 4 \
  --keep-monthly 6 \
  "$TARGET" || overall_status=1

echo "Compacting repository space..."
borg compact "$TARGET" || overall_status=1

# PRACTICE 2: Added Consistency Checks
echo "Checking repository structural integrity..."
borg check --repository-only "$TARGET" || overall_status=1

if [ "$(date +%d)" -eq 1 ]; then
  echo "First day of the month: Verifying data chunks..."
  borg check --verify-data "$TARGET" || overall_status=1
fi

if [ "${overall_status}" -eq 0 ]; then
  /usr/local/bin/alert 0 "backup geral bem sucedido"
  echo "Completed backup for $0 in $DATE"
else
  /usr/local/bin/alert 1 "backup geral mal sucedido"
  echo "Failed backup for $0 in $DATE"
fi

sync

if [ -f "$BACKUPCFG/autoeject" ]; then
  sudo umount "$MOUNTPOINT"
  sudo hdparm -Y "$drive"
fi

if [ -f "$BACKUPCFG/backup-suspend" ]; then
  systemctl suspend
fi

exit "${overall_status}"
