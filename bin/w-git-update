#!/usr/bin/env bash

set -o pipefail  # propagate errors
set -u  # exit on undefined
set -e  # exit on non-zero return value
#set -f  # disable globbing/filename expansion
shopt -s failglob  # error on unexpaned globs

conf_file=~/Documents/config/work-repo.conf
command='git update'

for repo_dir in $(cat "$conf_file"); do
  ~/Documents/scripts/work_repo_template.sh $repo_dir $command
done

