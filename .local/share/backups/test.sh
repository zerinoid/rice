#!/bin/bash -ue
sleep 5

export DISPLAY=:0
st -e bash -c "journalctl -fu automatic-backup -n 30 --user; read -p 'opa'" &

# The backup partition is mounted there
MOUNTPOINT=/mnt/backup

# This is the location of the Borg repository
TARGET=$MOUNTPOINT/borg-backups/saturno2024.borg

# Archive name schema
DATE=$(date --iso-8601)-$(hostname)

# This is the file that will later contain UUIDs of registered backup drives
BACKUPCFG=$HOME/.local/share/backups
DISKS=$BACKUPCFG/backup.disks

# Find whether the connected block device is a backup drive
for uuid in $(lsblk --noheadings --list --output uuid); do
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

echo "TRALALALALALALALa"
echo "TRALALALALALALALa"
echo "TRALALALALALALALa"
echo "TRALALALALALALALa"

# Just to be completely paranoid
sync

if [ -f $BACKUPCFG/autoeject ]; then
	sudo umount $MOUNTPOINT
	sudo hdparm -Y $drive
fi
