#!/bin/bash

user=`cut -d : -f 1 /etc/passwd | grep flo`
user_dir=/home/$user

fish_backup_dir=$user_dir/.local/share/fish/fish_backup
if [ ! -d $dir_to_search ]; then
  fish_backup_dir=$user_dir/.config/fish/fish_backup
fi

# Remove 10th file
trap "rm -f $fish_backup_dir/`ls -t $fish_backup_dir | sed -n 10p` 2>/dev/null" EXIT

# Get parent directory
fish_dir=`dirname $fish_backup_dir`
f_date=$(date '+%m-%d-%Y_%H-%M-%S')

cp $fish_dir/fish_history $fish_backup_dir/fish_history$f_date

