#!/usr/bin/env bash

set -o pipefail  # propagate errors
set -u  # exit on undefined
set -e  # exit on non-zero return value
#set -f  # disable globbing/filename expansion
shopt -s failglob  # error on unexpaned globs


source ~/Documents/scripts/source-me/mounts.sh

device_partition="$1"
mount_luks_device "$(pass encrypted_drives/backup_drive)" "$device_partition" /run/media/"$USER"/encrypted-backup-drive


