#!/usr/bin/env bash

set -o pipefail  # propagate errors
set -u  # exit on undefined
set -e  # exit on non-zero return value
#set -f  # disable globbing/filename expansion
shopt -s failglob  # error on unexpaned globs

files=()
while read -r line; do
  files+=("$line")
done < <(find ~/.local/state/nvim/undo/ -type f -mtime +182)  # 6 months

if [ "${#files[@]}" -lt 1 ]; then
  exit
fi

set -x
rm -f "${files[@]}"
set +x
