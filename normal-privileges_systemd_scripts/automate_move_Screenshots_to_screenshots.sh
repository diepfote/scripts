#!/bin/bash

user=`cut -d : -f 1 /etc/passwd | grep flo | head -n 1`
user_dir=/home/$user

mv $user_dir/Pictures/Screenshot* $user_dir/Pictures/screenshots/

if [ "?" != 0 ]; then
  echo -e "\033[1;32mNo new screenshots found.\033[0m"
fi

