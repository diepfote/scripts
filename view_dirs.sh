#!/usr/bin/env bash

set -o pipefail  # propagate errors
set -u  # exit on undefined
set -e  # exit on non-zero return value
#set -f  # disable globbing/filename expansion
shopt -s failglob  # error on unexpaned globs

source ~/Documents/scripts/source-me_progressbar.sh


DIR=~/Documents
FILES=$@

iterate_files()
{
  command="$1"

  for file in $FILES; do
    $command $DIR/$file
  done

}


trap 'echo; iterate_files "sudo chown -R root:root"; iterate_files "sudo chmod -R 000"' EXIT

iterate_files "sudo chown -R $USER:$USER"
iterate_files 'sudo chmod -R 700'

progressbar 'waiting to re-chown to root and re-chmod to 000' &

while (true); do
  sudo -v
  sleep 60
done

