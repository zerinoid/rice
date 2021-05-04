#!/bin/bash -ue

# The udev rule is not terribly accurate and may trigger our service before
# the kernel has finished probing partitions. Sleep for a bit to ensure
# the kernel is done.
#
# This can be avoided by using a more precise udev rule, e.g. matching
# a specific hardware path and partition.
sleep 5

# Output visual
export DISPLAY=:0 
st -e bash -c "journalctl -u automatic-backup -n 30 --user" &

#
# Script configuration
#

# The backup partition is mounted there
MOUNTPOINT=/mnt/backup

# This is the location of the Borg repository
TARGET=$MOUNTPOINT/borg-backups/backup.borg

# Archive name schema
DATE=$(date --iso-8601)-$(hostname)

# This is the file that will later contain UUIDs of registered backup drives
BACKUPCFG=$HOME/.local/share/backups
DISKS=$BACKUPCFG/backup.disks

# Find whether the connected block device is a backup drive
for uuid in $(lsblk --noheadings --list --output uuid)
do
        if grep --quiet --fixed-strings $uuid $DISKS; then
                break
        fi
        uuid=
done

if [ ! $uuid ]; then
        echo "No backup disk found, exiting"
        exit 0
fi

echo "Disk $uuid is a backup disk"
partition_path=/dev/disk/by-uuid/$uuid
# Mount file system if not already done. This assumes that if something is already
# mounted at $MOUNTPOINT, it is the backup drive. It won't find the drive if
# it was mounted somewhere else.
(sudo mount | grep $MOUNTPOINT) || sudo mount $partition_path $MOUNTPOINT
drive=$(lsblk --inverse --noheadings --list --paths --output name $partition_path | head --lines 1)
echo "Drive path: $drive"

#
# Create backups
#

# Options for borg create
BORG_OPTS="--stats --list --one-file-system --compression lz4 --checkpoint-interval 86400 --exclude-from "$BACKUPCFG"/exclude"

# Set BORG_PASSPHRASE or BORG_PASSCOMMAND somewhere around here, using export,
# if encryption is used.

# No one can answer if Borg asks these questions, it is better to just fail quickly
# instead of hanging.
export BORG_RELOCATED_REPO_ACCESS_IS_OK=no
export BORG_UNKNOWN_UNENCRYPTED_REPO_ACCESS_IS_OK=yes

# Log Borg version
borg --version

echo "Starting backup for $DATE"

shopt -s globstar

# teste
borg create $BORG_OPTS \
  $TARGET::$DATE-$$-teste \
  $HOME/tmp/ass

# DB
borg create $BORG_OPTS \
  $TARGET::$DATE-$$-db \
  $HOME/db $HOME/docs

# pessoais
borg create $BORG_OPTS \
  --exclude "**/node_modules" \
  $TARGET::$DATE-$$-pessoais \
  $HOME/pics $HOME/videos/Webcam $HOME/webdev/PESSOAIS $HOME/webdev/ESTUDOS

# sistema
borg create $BORG_OPTS \
  $TARGET::$DATE-$$-sistema \
  $HOME/.ssh $HOME/.env $HOME/.histdb

# musica
borg create $BORG_OPTS \
  $TARGET::$DATE-$$-musica \
  $HOME/music

# borg create $BORG_OPTS \
#   $TARGET::$DATE-$$-lenny \
#   $HOME/.ban

echo "Completed backup for $DATE"

# Just to be completely paranoid
sync

if [ -f $BACKUPCFG/autoeject ]; then
        sudo umount $MOUNTPOINT
        sudo hdparm -Y $drive
fi

if [ -f $BACKUPCFG/backup-suspend ]; then
        systemctl suspend
fi
