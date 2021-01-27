#!/usr/bin/env bash

set -o pipefail  # propagate errors
set -u  # exit on undefined
set -e  # exit on non-zero return value
#set -f  # disable globbing/filename expansion
shopt -s failglob  # error on unexpaned globs

set +u
[ -n "$2" ] && conf_file="$2" || conf_file=~/Documents/config/repo.conf
set -u

command="$1"

for repo_dir in $(cat "$conf_file"); do
  if [ "$(expr substr "$repo_dir" 1 1)" = '#' ] || [ -z "$repo_dir" ]; then
    # skip comment line & empty lines
    continue
  fi
  ~/Documents/scripts/work_repo_template.sh "$repo_dir" $command
done
