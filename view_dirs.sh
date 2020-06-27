#!/usr/bin/env bash

set -o pipefail  # propagate errors
set -u  # exit on undefined
set -e  # exit on non-zero return value
#set -f  # disable globbing/filename expansion
shopt -s failglob  # error on unexpaned globs

source ~/Documents/scripts/source-me_progressbar.sh
source ~/Documents/scripts/source-me_bash-nnn.sh


DIR=~/Documents
SUBDIRS=$@

iterate_files()
{
  command="$1"

  for subdir in $SUBDIRS; do
    set -x
    $command "$DIR/$subdir"
    set +x
  done


  set +u
  if [ -n "$initial"  ]; then
    set -x
    tmux split-window -d -v
    tmux send-keys -t .+ "n $DIR/$subdir" C-m
    tmux selectp -t .+
    set +x
  fi
  set -u

}


trap 'echo; iterate_files "sudo chown -R root:root"; iterate_files "sudo chmod -R 000"' EXIT

iterate_files "sudo chown -R $USER:$USER"
initial=true iterate_files 'sudo chmod -R 700'

progressbar 'waiting to re-chown to root and re-chmod to 000'

while (true); do
  sudo -v
  sleep 60
done

