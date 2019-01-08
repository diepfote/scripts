#!/usr/bin/env bash

user=$(cut -d : -f 1 /etc/passwd | grep flo)
user_dir=/home/$user  

script_dir=$user_dir/Documents/scripts
pass_dir=$user_dir/Documents/passwds

if [ ! -d $script_dir ]; then
  script_dir=$user_dir/Docs/scripts
  pass_dir=$user_dir/Dokumente/passwds
fi

pass=$($script_dir/read_pass.sh)


for part_file in "$@"
do
  for files in "$(find $pass_dir -iname "*$part_file*.gpg")"
  do 
    for file in $(echo -e $files) 
    do
      echo -e "----------------------\n$(basename $file)\n"
      echo $pass | gpg -d --batch --passphrase-fd 0 $file 2>/dev/null
      #echo $pass | gpg --cipher-algo AES256 -d --batch --passphrase-fd 0 $file 2>/dev/null
      echo -e "\n----------------------\n"
    done
  done
done

