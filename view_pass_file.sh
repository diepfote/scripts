#!/usr/bin/env bash

user=$(cut -d : -f 1 /etc/passwd | grep flo | head -n 1)
user_dir=$HOME  

script_dir=$user_dir/Documents/scripts
pass_dir=$user_dir/Documents/passwds

if [ ! -d $script_dir ]; then
  script_dir=$user_dir/Docs/scripts
  pass_dir=$user_dir/Dokumente/passwds
fi

pass=$($script_dir/read_pass.sh)
file=$(find $pass_dir -iname "$1*")

$script_dir/decrypt_file.sh "$pass" "$file"

