#!/usr/bin/env bash

set -u
set -e
set -o pipefail

source ~/Documents/scripts/source-me/common-functions.sh


cleanup () {
  file_30="$(find-sorted "$backup_dir" | sed -n 30p)"
  rm -f "$file_30" 2>/dev/null
}

fish_dir="$HOME/.local/share/fish"
if [ ! -d "$fish_dir" ]; then
  fish_dir="$HOME/.config/fish"
fi
backup_dir="$fish_dir/fish_backup"
[[ -d "$backup_dir" ]] || mkdir "$backup_dir"

f_date=$(date +%FT%T%Z | sed 's/:/_/g')

cp "$fish_dir/fish_history" "$backup_dir/fish_history$f_date"

