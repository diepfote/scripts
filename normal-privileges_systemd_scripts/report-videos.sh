#!/usr/bin/env bash

set -o pipefail  # propagate errors
set -u  # exit on undefined
set -e  # exit on non-zero return value
#set -f  # disable globbing/filename expansion
shopt -s failglob  # error on unexpaned globs

source ~/Documents/scripts/source-me/common-functions.sh
_add_to_PATH ~/Documents/python/tools/bin


end () {
  echo "[.] END   ppid:$ppid pid:$pid $(date)" >&2
}
trap end EXIT


LOCK_FILE=/tmp/report-videos-lock-file

abort () {
  source ~/Documents/scripts/source-me/colors.sh
  echo "${RED}[!]$NC an instance is already running. $ppid:$pid exiting." >&2
  echo "[.] lock file: $LOCK_FILE" >&2
  echo --- >&2
  echo "[.] grep report-videos" >&2
  ps -ef | grep -v grep | grep report-videos >&2

  exit 1
}


pid="$$"
ppid="$(ps -o ppid= "$pid" | sed -r 's#\s*##')"

_date="$(date)"
echo "[.] START ppid:$ppid pid:$pid $(date)" >&2


# !!!
# if the lockfile is older than 5 min just delete it an move on
find /tmp/report-videos-lock-file -mmin +5 -delete  >/dev/null 2>&1  || true  # ignore error for: no file
if [ -f "$LOCK_FILE" ]; then
  abort
fi
# !!!
touch "$LOCK_FILE"



local_video_syncer_storage=~/Documents/misc/videos
mkdir -p "$local_video_syncer_storage"

username="$(read_toml_setting ~/Documents/config/fastmail.conf username)"
fastmail_path='fastmail:'"$username"'.fastmail.com/files/videos'

if _rclone_verbose_sync_operation --update --delete-excluded "$fastmail_path" "$local_video_syncer_storage"; then

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
  _rclone_verbose_sync_operation --update --delete-excluded "$local_video_syncer_storage" "$fastmail_path"

  # sync mpv watch_later files
  find "$mpv_dir" ! -mtime -180 -delete  # delete files older than 180 days
  _rclone_verbose_sync_operation --update --delete-excluded "$mpv_dir" "$fastmail_path/$system-mpv-watch_later/"
fi


rm "$LOCK_FILE"
