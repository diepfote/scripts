#!/usr/bin/env bash

set -o pipefail  # propagate errors
set -u  # exit on undefined
set -e  # exit on non-zero return value
#set -f  # disable globbing/filename expansion
shopt -s failglob  # error on unexpaned globs

source ~/.sh_functions
source ~/Documents/scripts/source-me/prepare-file-to-report-videos.sh


dir=~/Documents/misc/videos
[ ! -d "$dir" ] && mkdir "$dir"

username="$(read_toml_setting ~/Documents/config/fastmail.conf username)"

if rclone sync --delete-excluded -v 'fastmail:'"$username"'.fastmail.com/files/videos' "$dir"; then
  [ "$(uname)" = Darwin ] && filename=videos-work.txt \
                          || filename=videos-home.txt
  write_current_videos_to_file "$dir" "$filename"

  rclone sync --delete-excluded -v "$dir" 'fastmail:'"$username"'.fastmail.com/files/videos'

fi

