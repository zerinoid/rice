#!/usr/bin/env bash
set -euo pipefail

sleep 5

/usr/local/bin/alert 0 "Começando backup ORGUE..."

DATE=$(date --iso-8601)
BACKUPCFG="$HOME/.local/share/backups"

# CRITICAL FIX 3: Local repository path to avoid cloud-sync corruption during writes
LOCAL_BORG_REP="$HOME/.local/share/borg-repos/org.borg"
# Rclone remote & target path (adjust remote name if different)
RCLONE_REMOTE="gdrive:org-bkp/org.borg"

if [[ ! -d "$LOCAL_BORG_REP" ]]; then
  mkdir -p "$LOCAL_BORG_REP"
fi

if [[ -f "$HOME/.env" ]]; then
  # shellcheck source=/dev/null
  . "$HOME/.env"
  export BORG_PASSPHRASE="${ORG_BKP_PASS:-}"
fi

export BORG_RELOCATED_REPO_ACCESS_IS_OK=no
export BORG_UNKNOWN_UNENCRYPTED_REPO_ACCESS_IS_OK=yes

info() { printf "\n%s %s\n\n" "$(date)" "$*" >&2; }

# CRITICAL FIX 1: Array representation prevents broken paths with spaces
BORG_OPTS=(
  --stats
  --list
  --one-file-system
  --compression zstd,3
  --checkpoint-interval 86400
  --exclude-from "$BACKUPCFG/exclude-org"
)

info "Starting local Borg backup..."
borg create "${BORG_OPTS[@]}" \
  "$LOCAL_BORG_REP::{hostname}-$DATE-$$-knowledge" \
  "$HOME/docs/org" \
  "$HOME/.emacs.d/private/snippets" \
  "$HOME/docs/bkp" \
  "$HOME/docs/cv-typst" \
  "$HOME/docs/contratos"
backup_exit=$?

info "Pruning repository..."
borg prune \
  --list \
  --keep-daily 7 \
  --keep-weekly 4 \
  --keep-monthly 3 \
  "$LOCAL_BORG_REP"
prune_exit=$?

info "Compacting repository space..."
borg compact "$LOCAL_BORG_REP"

# PRACTICE 2 & 3: Integrity Checks
info "Running structural integrity check..."
borg check --repository-only "$LOCAL_BORG_REP"

# Run full data verification only on the 1st day of the month
if [ "$(date +%d)" -eq 1 ]; then
  info "First day of the month: Running full data integrity check (bit rot prevention)..."
  borg check --verify-data "$LOCAL_BORG_REP"
fi

global_exit=$((backup_exit > prune_exit ? backup_exit : prune_exit))

if [ "${global_exit}" -eq 0 ]; then
  info "Local backup, prune, and compact successful. Syncing to Google Drive..."

  # CRITICAL FIX 3: Automated Google Drive Sync via rclone
  if command -v rclone &>/dev/null; then
    rclone sync "$LOCAL_BORG_REP" "$RCLONE_REMOTE" \
      --transfers 4 \
      --checkers 8 \
      --tpslimit 10 \
      --drive-use-trash=false \
      --stats 10s \
      -v
    sync_exit=$?
    if [ "${sync_exit}" -eq 0 ]; then
      info "Google Drive sync finished successfully."
      /usr/local/bin/alert 0 "backup ORGUE bem sucedido"
    else
      info "Google Drive sync failed with exit code ${sync_exit}."
      /usr/local/bin/alert "${sync_exit}" "backup ORGUE falhou no sync Google Drive"
      exit "${sync_exit}"
    fi
  else
    info "Warning: rclone not found. Skipping Google Drive transfer."
    /usr/local/bin/alert 0 "backup ORGUE concluído (apenas local)"
  fi
else
  info "Backup or Prune failed with exit code ${global_exit}."
  /usr/local/bin/alert "${global_exit}" "backup ORGUE falhou"
fi

exit "${global_exit}"
