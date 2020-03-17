#!/usr/bin/env bash

set -o pipefail  # propagate errors
set -u  # exit on undefined
set -e  # exit on non-zero return value
#set -f  # disable globbing/filename expansion
shopt -s failglob  # error on unexpaned globs


password_storage_folder=~/Documents/boxcryptor_container/data/temp_pass
#password_storage_folder=~/VirtualBox_VMs/#_win_shared/temp_pass
trap "rm -rf "$password_storage_folder"" EXIT
mkdir "$password_storage_folder"

set +u
if [ -z "$1" ]; then
  FILES=$(find ~/.password-store/ -name '*.gpg')
else
  FILES=$@
fi
set -u

for file in $FILES; do
  dir="$(dirname "$file" | sed -r 's#.*\.password-store##g;s#^/##')"
  file="$(basename "$file" | sed 's#\.gpg##')"

  echo '-----------------'
  echo "dir $dir"
  echo "file $file"


  if [ -n "$dir" ]; then
    mkdir -p "$password_storage_folder/$dir"
    pass "$dir/$file" > "$password_storage_folder/$dir/$file.txt"
  else
    pass "$file" > "$password_storage_folder/$file.txt"
  fi

done

sleep infinity

