#!/usr/bin/env bash

set -o pipefail  # propagate errors
set -u  # exit on undefined
set -e  # exit on non-zero return value
#set -f  # disable globbing/filename expansion
shopt -s failglob  # error on unexpaned globs

source ~/Documents/scripts/source-me/common-functions.sh
_add_to_PATH ~/Documents/python/tools/bin


end () {
  set +x
  echo "[.] END   ppid:$ppid pid:$pid $(date)" >&2
  rm "$LOCK_FILE" || true
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


if [ -f "$LOCK_FILE" ]; then
  abort
fi
# !!!
touch "$LOCK_FILE"


local_video_syncer_storage=~/Documents/misc/videos
mkdir -p "$local_video_syncer_storage"

remote_path='proton:videos'

system=arch
mpv_dir=~/.local/state/mpv/watch_later/
video_syncer_file=videos-home.txt
if [ "$(uname)" = Darwin ]; then
  video_syncer_file=videos-work.txt
  system=mac
  mpv_dir=~/.config/mpv/watch_later/
fi


# write mapping file
set -x
~/Documents/golang/tools/sync-video-syncer-mpv-watch-later-files/sync-video-syncer-mpv-watch-later-files create-mapping-file
set +x


if rclone sync --checksum --delete-excluded "$remote_path" "$local_video_syncer_storage"; then
  # cleanup redirection entries
  find "$mpv_dir" -size 17c -exec bash -c 'if grep -F "# redirect entry" "$0" >/dev/null; then rm "$0"; fi;' {} \;

  ~/Documents/scripts/bin/_prepare-file-to-report-videos "$local_video_syncer_storage/$video_syncer_file"

  # sync video-syncer file
  rclone sync --checksum --delete-excluded "$local_video_syncer_storage" "$remote_path"

  # sync mpv watch_later files
  find "$mpv_dir" ! -mtime -180 -delete  # delete files older than 180 days
  rclone sync --checksum --delete-excluded "$mpv_dir" "$remote_path/$system-mpv-watch_later/"
fi


# update watch_later config (if remote is further along)
set -x
~/Documents/golang/tools/sync-video-syncer-mpv-watch-later-files/sync-video-syncer-mpv-watch-later-files --no-dry-run
set +x

