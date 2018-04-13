#!/usr/bin/bash
user=`cut -d : -f 1 /etc/passwd | grep flo`
user_dir=/home/$user

find $user_dir/Pictures/ -type f -exec chmod 600 {} +

