#!/usr/bin/env bash

set -o pipefail  # propagate errors
set -u  # exit on undefined
set -e  # exit on non-zero return value
#set -f  # disable globbing/filename expansion
shopt -s failglob  # error on unexpaned globs

source ~/.sh_functions


write_current_videos_to_file()
{
  find ~/Videos -path "$HOME/Videos/watched" -prune -o -name '*.mp4' -exec sh -c \
    'end="$(echo "{}" | sed "s#.*-##;s#.mp4##")"; python3 -c "import sys; end = sys.argv[1]; name = sys.argv[2]; \
    print(name.split(\"Videos/\")[1]) if len(end) == 11 else print(end=\"\")" "$end" "{}"' \; > "$dir"/videos.txt 2>/dev/null || true
}

dir=~/Documents/misc/videos
[ ! -d "$dir" ] && mkdir "$dir"

username="$(read_toml_setting ~/Documents/config/fastmail.conf username)"

set -x
write_current_videos_to_file
set +x
rclone sync --delete-excluded -v "$dir" 'fastmail:'$username'.fastmail.com/files/videos'

