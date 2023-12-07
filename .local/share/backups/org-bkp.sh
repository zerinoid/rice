#!/bin/bash -ue

sleep 5

DATE=$(date --iso-8601)

BORG_OPTS="--stats --list --one-file-system --compression lz4 --checkpoint-interval 86400"

BORG_REP=$HOME/drive/org-bkp/org.borg

###########################
export BORG_PASSPHRASE="${ORG_BKP_PASS}"
# export BORG_PASSCOMMAND=something
export BORG_RELOCATED_REPO_ACCESS_IS_OK=no
export BORG_UNKNOWN_UNENCRYPTED_REPO_ACCESS_IS_OK=yes

info() { printf "\n%s %s\n\n" "$(date)" "$*" >&2; }
borg --version

info "Starting backup"

borg create $BORG_OPTS \
	$BORG_REP::{hostname}-$DATE-$$-knowledge \
	$HOME/docs/org $HOME/.emacs.d/private/snippets $HOME/docs/bkp

backup_exit=$?

info "Pruning repository"

borg prune \
	--list \
	--keep-daily 7 \
	--keep-weekly 4 \
	--keep-monthly 3 \
	$BORG_REP

prune_exit=$?

global_exit=$((backup_exit > prune_exit ? backup_exit : prune_exit))

if [ ${global_exit} -eq 0 ]; then
	info "Backup and Prune finished successfully"
	/usr/local/bin/alert $global_exit "$0" "terminado em $DATE"
elif [ ${global_exit} -eq 1 ]; then
	info "Backup and/or Prune finished with warnings"
	/usr/local/bin/alert $global_exit "$0" "deu erro em $DATE"
else
	info "Backup and/or Prune finished with errors"
	/usr/local/bin/alert $global_exit "$0" "falhou $DATE"
fi

exit ${global_exit}
