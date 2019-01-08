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

file=$(find $pass_dir -iname "$1*.gpg")
if [ "$(uname -a | grep Ubuntu)" == "" ]; then
  echo $pass | gpg --no-symkey-cache --cipher-algo AES256 -d --batch --passphrase-fd 0 $file 2>/dev/null
else
  echo $pass | gpg --cipher-algo AES256 -d --batch --passphrase-fd 0 $file 2>/dev/null
fi

