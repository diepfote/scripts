#!/bin/bash

user=`cut -d : -f 1 /etc/passwd | grep flo | head -n 1`
user_dir=/home/$user

dir=$user_dir/Documents

if [ ! -d $dir ]; then
  dir=$user_dir/Docs
fi

$dir/scripts/view_pass_file.sh ***REMOVED***_pass
