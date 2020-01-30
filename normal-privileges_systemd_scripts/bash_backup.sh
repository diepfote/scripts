#!/bin/bash

user="$(cut -d : -f 1 /etc/passwd | grep flo | head -n 1)"
user_dir="$HOME"

bash_backup_dir="$user_dir/bash_backup"
[[ -d "$bash_backup_dir" ]] || mkdir "$bash_backup_dir"

# Remove 10th file
trap "rm -f $bash_backup_dir/$(ls -t $bash_backup_dir | sed -n 10p) 2>/dev/null" EXIT

# Get parent directory
f_date=$(date +%FT%T%Z | sed 's/:/_/g')

cp "$user_dir/.bash_history" "$bash_backup_dir/bash_history$f_date"

pwd

