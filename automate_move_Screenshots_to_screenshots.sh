#!/bin/bash

user=`cut -d : -f 1 /etc/passwd | grep flo`
user_dir=/home/$user

mv $user_dir/Pictures/Screenshot* $user_dir/Pictures/screenshots/

