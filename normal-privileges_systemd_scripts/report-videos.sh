#!/usr/bin/env bash

set -o pipefail  # propagate errors
set -u  # exit on undefined
set -e  # exit on non-zero return value
#set -f  # disable globbing/filename expansion
shopt -s failglob  # error on unexpaned globs


source ~/Documents/scripts/source-me/common-functions.sh
_add_to_PATH ~/Documents/python/tools/bin

local_video_syncer_storage=~/Documents/misc/videos
mkdir -p "$local_video_syncer_storage"

username="$(read_toml_setting ~/Documents/config/fastmail.conf username)"
fastmail_path='fastmail:'"$username"'.fastmail.com/files/videos'

if _rclone_verbose_sync_operation --delete-excluded "$fastmail_path" "$local_video_syncer_storage"; then

  video_syncer_file=videos-home.txt
  system=arch
  mpv_dir=~/.local/state/mpv/watch_later/
  if [ "$(uname)" = Darwin ]; then
    video_syncer_file=videos-work.txt
    system=mac
    mpv_dir=~/.config/mpv/watch_later/
  fi

  ~/Documents/scripts/bin/_prepare-file-to-report-videos "$local_video_syncer_storage/$video_syncer_file"

  # sync video-syncer file
  _rclone_verbose_sync_operation --delete-excluded "$local_video_syncer_storage" "$fastmail_path"

  # sync mpv watch_later files
  find "$mpv_dir" ! -mtime -180 -delete  # delete files older than 180 days
  _rclone_verbose_sync_operation --delete-excluded "$mpv_dir" "$fastmail_path/$system-mpv-watch_later/"
fi

