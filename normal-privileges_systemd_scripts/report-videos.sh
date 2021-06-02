#!/usr/bin/env bash

set -o pipefail  # propagate errors
set -u  # exit on undefined
set -e  # exit on non-zero return value
#set -f  # disable globbing/filename expansion
shopt -s failglob  # error on unexpaned globs


source ~/Documents/scripts/source-me/common-functions.sh
source ~/Documents/scripts/source-me/prepare-file-to-report-videos.sh


dir=~/Documents/misc/videos
[ ! -d "$dir" ] && mkdir "$dir"

username="$(read_toml_setting ~/Documents/config/fastmail.conf username)"
fastmail_path='fastmail:'"$username"'.fastmail.com/files/videos'

if _rclone_verbose_sync_operation --delete-excluded "$fastmail_path" "$dir"; then
  [ "$(uname)" = Darwin ] && filename=videos-work.txt \
                          || filename=videos-home.txt

  write_current_videos_to_file "$dir/$filename"

  _rclone_verbose_sync_operation --delete-excluded "$dir" "$fastmail_path"

fi

