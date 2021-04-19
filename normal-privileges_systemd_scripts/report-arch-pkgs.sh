#!/usr/bin/env bash

set -o pipefail  # propagate errors
set -u  # exit on undefined
set -e  # exit on non-zero return value
#set -f  # disable globbing/filename expansion
shopt -s failglob  # error on unexpaned globs


source ~/Documents/scripts/source-me/common-functions.sh
source ~/Documents/scripts/source-me/posix-compliant-shells.sh


dir=~/Documents/misc/arch
[ ! -d "$dir" ] && mkdir "$dir"

username="$(read_toml_setting ~/Documents/config/fastmail.conf username)"
fastmail_path='fastmail:'"$username"'.fastmail.com/files/-configs/arch'

if _rclone_verbose_sync_operation --delete-excluded "$fastmail_path" "$dir"; then

  # TODO pacman logic


  _rclone_verbose_sync_operation --delete-excluded "$dir" "$fastmail_path"

fi

