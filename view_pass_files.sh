#!/usr/bin/env bash

user=$(cut -d : -f 1 /etc/passwd | grep flo)
user_dir=/home/$user  

dir=$user_dir/Documents

if [ ! -d $dir ]; then
  set dir $user_dir/Dokumente
fi

pass_dir=$dir/passwds

pass=$($dir/scripts/read_pass.sh)


for part_file in "$@"
do
  for files in "$(find $pass_dir -iname "*$part_file*.gpg")"
  do 
    for file in $(echo -e $files) 
    do
      echo -e "----------------------\n$(basename $file)\n"
      echo $pass | gpg -d --batch --passphrase-fd 0 $file 2>/dev/null
      echo -e "\n----------------------\n"
    done
  done
done

