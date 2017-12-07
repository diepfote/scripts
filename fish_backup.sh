#!/bin/bash

if [ $SUDO_USER ]; then user=$SUDO_USER; else user=`whoami`; fi
user_dir=/home/$user

fish_backup_dir=`sudo find $user_dir -name fish_backup 2>/dev/null`

# Get parent directory
fish_dir=`dirname $fish_backup_dir`
f_date=$(date '+%m-%d-%Y_%H-%M-%S')

# Remove 10th file
trap "rm -f $fish_backup_dir/`ls -t $fish_backup_dir | sed -n 10p` 2>/dev/null" EXIT

cp $fish_dir/fish_history $fish_backup_dir/fish_history$f_date

