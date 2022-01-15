#!/usr/bin/env bash

set -u
set -e
set -o pipefail

source ~/Documents/scripts/source-me/common-functions.sh


backup_dir="$HOME/.bash_backup"
[[ -d "$backup_dir" ]] || mkdir "$backup_dir"

cleanup () {
  file_30="$(find-sorted "$backup_dir" | sed -n 30p)"
  rm -f "$file_30" 2>/dev/null
}

# Get parent directory
fish_dir="$(dirname "$backup_dir")"
f_date=$(date +%FT%T%Z | sed 's/:/_/g')

cp "$fish_dir/fish_history" "$backup_dir/fish_history$f_date"

