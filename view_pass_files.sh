#!/usr/bin/env bash

pass_dir=~/Documents/passwds
script_dir=~/Documents/scripts

pass=$("$script_dir"/read_pass.sh)

for part_file in "$@"; do
  for file in $(find $pass_dir -iname "*$part_file*"); do
    echo -e "----------------------\n$(basename $file)\n"
    $script_dir/decrypt_file.sh "$pass" "$file"
    echo -e "\n----------------------\n"
  done
done

