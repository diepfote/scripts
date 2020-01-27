#!/usr/bin/env bash

user=$(cut -d : -f 1 /etc/passwd | grep flo | head -n 1)
user_dir=$HOME  

pass_dir=$user_dir/Documents/passwds

if [ ! -d $script_dir ]; then
  pass_dir=$user_dir/Dokumente/passwds
fi


for part_file in "$@"; do
  echo -e "----------------------\nMatches for '$part_file': \n"
  
  for file in $(find $pass_dir -iname "*$part_file*"); do
    echo -e "$(basename $file)\n"
  done
  
  echo -e "----------------------\n"
done


