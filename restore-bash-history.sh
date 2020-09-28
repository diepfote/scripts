#!/usr/bin/env bash

set -o pipefail  # propagate errors
set -u  # exit on undefined
set -e  # exit on non-zero return value
#set -f  # disable globbing/filename expansion
shopt -s failglob  # error on unexpaned globs


tmp_bash_history_file="/tmp/.bash_history"
bash_history_file=~/.bash_history
ls -al "$bash_history_file"
trap "sleep 60 && rm "$tmp_bash_history_file" &" EXIT  # keep file for x seconds

path=~/.bash_backup/
largest_backup_file="$path/$(ls -S "$path" | head -n1)"
ls -al "$largest_backup_file"

cp "$largest_backup_file" "$tmp_bash_history_file"
cat "$bash_history_file" >> "$tmp_bash_history_file"
ls -al "$tmp_bash_history_file"

cp "$bash_history_file" "$bash_history_file".bck
cp "$tmp_bash_history_file" "$bash_history_file"

