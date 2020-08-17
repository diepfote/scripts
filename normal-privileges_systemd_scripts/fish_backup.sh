#!/usr/bin/env bash

set -u
set -e
set -o pipefail

fish_backup_dir=~/.local/share/fish/fish_backup
[[ ! -d "$fish_backup_dir" ]] && mkdir "$fish_backup_dir"

# Remove 30th file
trap "rm -f $fish_backup_dir/$(ls -t $fish_backup_dir | sed -n 30p) 2>/dev/null" EXIT

# Get parent directory
fish_dir="$(dirname "$fish_backup_dir")"
f_date=$(date +%FT%T%Z | sed 's/:/_/g')

cp "$fish_dir/fish_history" "$fish_backup_dir/fish_history$f_date"

