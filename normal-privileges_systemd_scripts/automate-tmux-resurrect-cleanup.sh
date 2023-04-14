#!/usr/bin/env bash

set -o pipefail  # propagate errors
set -u  # exit on undefined
set -e  # exit on non-zero return value
#set -f  # disable globbing/filename expansion
shopt -s failglob  # error on unexpaned globs

files=()
while read -r line; do
  files+=("$line")
done < <(find ~/.tmux/resurrect -type f -mtime +14)

if [ "${#files[@]}" -lt 1 ]; then
  exit
fi

set -x
rm "${files[@]}"
set +x
