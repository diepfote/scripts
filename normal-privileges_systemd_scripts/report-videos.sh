#!/usr/bin/env bash

set -o pipefail  # propagate errors
set -u  # exit on undefined
set -e  # exit on non-zero return value
#set -f  # disable globbing/filename expansion
shopt -s failglob  # error on unexpaned globs


source ~/Documents/scripts/source-me/posix-compliant-shells.sh


temp="$(mktemp -d)"


end () {
  rm -r "$temp"
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

username="$(read_toml_setting ~/Documents/config/fastmail.conf username)"
fastmail_path='fastmail:'"$username"'.fastmail.com/files/videos'
proton_path='proton:videos'

system=arch
remote_system=mac
mpv_dir=~/.local/state/mpv/watch_later/
video_syncer_file=videos-home.txt
video_syncer_file_remote=videos-work.txt
if [ "$(uname)" = Darwin ]; then
  video_syncer_file=videos-work.txt
  video_syncer_file_remote=videos-home.txt
  system=mac
  remote_system=arch
  mpv_dir=~/.config/mpv/watch_later/
fi


exec_fetch="$temp/exec-fetch.sh"
detect_error="$temp"/error
# FETCH
{
  echo '#!/usr/bin/env bash'
  echo rclone sync --checksum "$proton_path/$video_syncer_file_remote" "$local_video_syncer_storage"
  # echo 'echo exit code $?'
  echo 'if [ $? -ne 0 ]; then echo proton > '"$detect_error"'; fi'

  echo rclone sync --update "$fastmail_path/${remote_system}-mpv-watch_later/" "$local_video_syncer_storage/${remote_system}-mpv-watch_later/"
  # echo 'echo exit code $?'
  echo 'if [ $? -ne 0 ]; then echo fastmail > '"$detect_error"'; fi'
} > "$exec_fetch"
chmod +x "$exec_fetch"

# to execute 2 subtasks
touch "$temp"/{1,2}
execute-on-files -no-header -workers 8 -config <(ls "$temp"/{1,2}) "$exec_fetch"

if [ -e "$detect_error" ]; then
  echo "${RED}[!]$NC Fetch failed: $(cat "$detect_error") | Exiting early."
  exit 10
fi


# ---------


# cleanup redirection entries
find "$mpv_dir" -size 17c -exec bash -c 'if grep -F "# redirect entry" "$0" >/dev/null; then rm "$0"; fi;' {} \;
# sync mpv watch_later files
find "$mpv_dir" ! -mtime -180 -delete  # delete files older than 180 days

set -x
# write videos-<system> file
~/Documents/scripts/bin/_prepare-file-to-report-videos "$local_video_syncer_storage/$video_syncer_file"
# write mpv watch-later mapping file
~/Documents/golang/tools/sync-video-syncer-mpv-watch-later-files/sync-video-syncer-mpv-watch-later-files create-mapping-file
set +x

# PUSH
exec_push="$temp/exec-push.sh"
{
  echo '#!/usr/bin/env bash'
  echo rclone sync --checksum --exclude  arch-mpv-watch_later --exclude mac-mpv-watch_later "$local_video_syncer_storage" "$proton_path"
  # echo 'echo exit code $?'
  echo 'if [ $? -ne 0 ]; then echo proton > '"$detect_error"'; fi'

  echo rclone sync --update "$mpv_dir" "$fastmail_path/${system}-mpv-watch_later/"
  # echo 'echo exit code $?'
  echo 'if [ $? -ne 0 ]; then echo fastmail > '"$detect_error"'; fi'
} > "$exec_push"
chmod +x "$exec_push"
execute-on-files -no-header -workers 8 -config <(ls "$temp"/{1,2}) "$exec_fetch"

if [ -e "$detect_error" ]; then
  echo "${RED}[!]$NC Push failed: $(cat "$detect_error") | Continuing."
  exit 11
fi

# update local watch_later config (if remote is further along)
set -x
~/Documents/golang/tools/sync-video-syncer-mpv-watch-later-files/sync-video-syncer-mpv-watch-later-files --no-dry-run
set +x

