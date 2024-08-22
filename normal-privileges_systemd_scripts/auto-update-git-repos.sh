#!/usr/bin/env bash

set -o pipefail  # propagate errors
set -u  # exit on undefined
set -e  # exit on non-zero return value
#set -f  # disable globbing/filename expansion
shopt -s failglob  # error on unexpaned globs


~/Documents/golang/tools/execute-in-repos/execute-in-repos -config <(find ~/Documents/auto-update-git-repos -mindepth 1 -maxdepth 1 -type d) -- git pull

