#!/usr/bin/env bash

user=$(cut -d : -f 1 /etc/passwd | grep flo)
user_dir=/home/$user  

dir=$user_dir/Documents

if [ ! -d $dir ]; then
  set dir $user_dir/Dokumente
fi

pass_dir=$dir/passwds

pass=$($dir/scripts/read_pass.sh)

file=$(find $pass_dir -iname "*$1*.gpg")
echo $pass | gpg -d --batch --passphrase-fd 0 $file 2>/dev/null

