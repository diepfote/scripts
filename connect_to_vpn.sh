#!/usr/bin/env bash

user=$(cut -d : -f 1 /etc/passwd | grep flo)
user_dir=/home/$user  

script_dir=$user_dir/Documents/scripts
pass_dir=$user_dir/Documents/passwds

temp=$(mktemp -d)
trap 'rm -rf $temp' EXIT

if [ ! -d $script_dir ]; then
  script_dir=$user_dir/Docs/scripts
  pass_dir=$user_dir/Dokumente/passwds
fi

creds=$($script_dir/view_pass_file.sh ***REMOVED*******REMOVED*** --config "$pass_dir/../***REMOVED***_strong/$1.ovpn" --auth-user-pass $creds_file &
  sleep 10

  rm -rf $temp
  fg 1
fi

