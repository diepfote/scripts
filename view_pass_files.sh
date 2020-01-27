#!/usr/bin/env bash

pass_dir=~/Documents/passwds

if [ ! -d $script_dir ]; then
  script_dir=~/Docs/scripts
  pass_dir=~/Dokumente/passwds
fi

pass=$($script_dir/read_pass.sh)

for part_file in "$@"; do
  for file in $(find $pass_dir -iname "*$part_file*"); do
    echo -e "----------------------\n$(basename $file)\n"
    $script_dir/decrypt_file.sh "$pass" "$file"
    echo -e "\n----------------------\n"
  done
done

