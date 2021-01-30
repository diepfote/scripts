#!/usr/bin/env bash

set -o pipefail  # propagate errors
set -u  # exit on undefined
set -e  # exit on non-zero return value
#set -f  # disable globbing/filename expansion
shopt -s failglob  # error on unexpaned globs

source ~/Documents/scripts/source-me/spinner.sh
source ~/.sh_functions

iterate_files()
{
  command="$1"

  for subdir in $SUBDIRS; do
    set -x
    $command "$DIR/$subdir"
    set +x

    set +u
    if [ -n "$open_nnn"  ]; then
      unset open_nnn
      n-for-dir-in-tmux-pane-below "$DIR/$subdir"
    fi
    set -u
  done


}


DIR=~/Documents
SUBDIRS=$@


trap 'echo; iterate_files "sudo chown -R root:root"; iterate_files "sudo chmod -R 000"' EXIT

iterate_files "sudo chown -R $USER:$USER"
open_nnn=true iterate_files 'sudo chmod -R 700'

spinner 'waiting to re-chown to root and re-chmod to 000'

while (true); do
  sudo -v
  sleep 60
done

