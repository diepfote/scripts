#!/usr/bin/env bash

set -o pipefail
set -u
set -e

source ~/Documents/scripts/source-me/common-functions.sh


backup_dir="$HOME/.bash_backup"
[[ -d "$backup_dir" ]] || mkdir "$backup_dir"

cleanup () {
  file_30="$(find-sorted "$backup_dir" | sed -n 30p)"
  rm -f "$file_30" 2>/dev/null
}
trap "cleanup" EXIT

# Get parent directory
f_date=$(date +%FT%T%Z | sed 's/:/_/g')

[ -f "$HOME/.bash_history_x" ] && HISTFILE="$HOME/.bash_history_x" || HISTFILE="$HOME/.bash_history"
cp "$HISTFILE" "$backup_dir/bash_history$f_date"

