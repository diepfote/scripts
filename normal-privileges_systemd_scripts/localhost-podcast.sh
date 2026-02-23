#!/usr/bin/env bash

set -o pipefail  # propagate errors
set -u  # exit on undefined
set -e  # exit on non-zero return value
#set -f  # disable globbing/filename expansion
shopt -s failglob  # error on unexpaned globs

work_dir="$(~/.bin/read-ini-setting ~/.config/personal/services.conf work_dir localhost-podcast)"

(cd "$work_dir" && ~/.bin/localhost-podcast run)

