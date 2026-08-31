#!/usr/bin/env bash
set -euo pipefail

sleep 5

# Visual output (apenas se houver sessão X11 ativa)
export DISPLAY="${DISPLAY:-:0}"
export XAUTHORITY="${XAUTHORITY:-$HOME/.Xauthority}"
export DBUS_SESSION_BUS_ADDRESS="${DBUS_SESSION_BUS_ADDRESS:-unix:path=/run/user/$(id -u)/bus}"

alacritty -e bash -c "journalctl --user -fu sys-bkp -n 30; echo 'Backup process finished. Press Enter to close...'; read -r" &

MOUNTPOINT=/mnt/backup
TARGET="$MOUNTPOINT/borg-backups/$(hostname).borg"
DATE="$(date --iso-8601)-$(hostname)"

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
echo "Starting consolidated backup for $DATE"

overall_status=0

# 1. Criação do backup único com todos os diretórios
echo "Creating unified backup archive..."
borg create "${BORG_OPTS[@]}" \
  "$TARGET::$DATE-$$-sys-bkp" \
  "$HOME/db" \
  "$HOME/docs" \
  "$HOME/pics" \
  "$HOME/videos" \
  "$HOME/.ssh" \
  "$HOME/.env" \
  "$HOME/.cache/histdb" \
  "$HOME/.cache/zsh/history" \
  "$HOME/music" \
  "$HOME/.ban" \
  "$HOME/tmp/mac" || overall_status=1

# 2. Prune seguro
echo "Pruning older backups..."
borg prune \
  --list \
  --glob-archives "*-sys-bkp" \
  --keep-daily 7 \
  --keep-weekly 4 \
  --keep-monthly 6 \
  "$TARGET" || overall_status=1

# 3. Compactação
echo "Compacting repository space..."
borg compact "$TARGET" || overall_status=1

# 4. Checagens de integridade
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

if [ -f "$BACKUPCFG/suspend" ]; then
  systemctl suspend
fi

exit "${overall_status}"
