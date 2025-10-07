#!/usr/bin/env bash

set -o pipefail  # propagate errors
set -u  # exit on undefined
set -e  # exit on non-zero return value
#set -f  # disable globbing/filename expansion
shopt -s failglob  # error on unexpaned globs


source ~/Repos/scripts/source-me/posix-compliant-shells.sh


temp="$(mktemp -d)"


end () {
  # rm -r "$temp"
  set +x
  echo "[.] END   ppid:$ppid pid:$pid $(date)" >&2
  rm "$LOCK_FILE" || true
}
trap end EXIT


LOCK_FILE=/tmp/report-videos-lock-file

abort () {
  source ~/Repos/scripts/source-me/colors.sh
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


local_video_syncer_storage=~/.config/personal/sync-config/videos
mkdir -p "$local_video_syncer_storage"

rsync_path=rsync.net:state/videos


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


exec_fetch1="$temp/1"
detect_error="$temp"/error
# FETCH
{
  echo '#!/usr/bin/env bash'

  echo rsync -av  "$rsync_path/$video_syncer_file_remote"   "$local_video_syncer_storage"
  # echo 'echo exit code $?'
  echo 'if [ $? -ne 0 ]; then echo -n video-file-to-local, >> '"$detect_error"'; fi'

} > "$exec_fetch1"
exec_fetch2="$temp/2"
{
  echo '#!/usr/bin/env bash'

  echo rsync -av --delete  "$rsync_path/${remote_system}-mpv-watch_later/"   "$local_video_syncer_storage/${remote_system}-mpv-watch_later/"
  # echo 'echo exit code $?'
  echo 'if [ $? -ne 0 ]; then echo -n remote-watch-later-to-local, >> '"$detect_error"'; fi'

} > "$exec_fetch2"

execute-on-files -workers 2 -config <(ls "$temp"/{1,2}) bash

if [ -e "$detect_error" ]; then
  echo "${RED}[!]$NC Fetch failed: $(cat "$detect_error")."
  rm "$detect_error"
  # exit 10
fi


# ---------


# cleanup redirection entries
find "$mpv_dir" -size 17c -exec bash -c 'if grep -F "# redirect entry" "$0" >/dev/null; then rm "$0"; fi;' {} \;
# sync mpv watch_later files
find "$mpv_dir" ! -mtime -180 -delete  # delete files older than 180 days

set -x
# write videos-<system> file
~/Repos/scripts/bin/_prepare-file-to-report-videos "$local_video_syncer_storage/$video_syncer_file"  || true
# update local watch_later config (if remote is further along)
~/Repos/golang/tools/sync-video-syncer-mpv-watch-later-files/sync-video-syncer-mpv-watch-later-files --no-dry-run
# write mpv watch-later mapping file
~/Repos/golang/tools/sync-video-syncer-mpv-watch-later-files/sync-video-syncer-mpv-watch-later-files create-mapping-file
set +x

# PUSH
exec_push1="$temp/1"
{
  echo '#!/usr/bin/env bash'

  echo rsync -av  "$local_video_syncer_storage/$video_syncer_file"   "$rsync_path/$video_syncer_file"
  # echo 'echo exit code $?'
  echo 'if [ $? -ne 0 ]; then echo -n video-file-to-remote, >> '"$detect_error"'; fi'

} > "$exec_push1"
exec_push2="$temp/2"
{
  echo '#!/usr/bin/env bash'

  echo rsync -av  "$local_video_syncer_storage/mapping.txt"   "$rsync_path/mapping.txt"
  # echo 'echo exit code $?'
  echo 'if [ $? -ne 0 ]; then echo -n mapping-file-to-remote, >> '"$detect_error"'; fi'

} > "$exec_push2"
exec_push3="$temp/3"
{
  echo '#!/usr/bin/env bash'

  echo rsync -av --delete  "$mpv_dir"   "$rsync_path/${system}-mpv-watch_later/"
  # echo 'echo exit code $?'
  echo 'if [ $? -ne 0 ]; then echo -n watch-later-to-remote, >> '"$detect_error"'; fi'

} > "$exec_push3"
execute-on-files -workers 3 -config <(ls "$temp"/{1,2,3}) bash

if [ -e "$detect_error" ]; then
  echo "${RED}[!]$NC Push failed: $(cat "$detect_error")."
  # wipe
  rm "$detect_error"
fi


