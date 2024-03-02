#!/usr/bin/env bash

# all of these stem from https://www.shellcheck.net/wiki/
set -o pipefail  # propagate errors
set -u  # exit on undefined
set -e  # exit on non-zero return value
#set -f  # disable globbing/filename expansion
shopt -s failglob  # error on unexpaned globs
shopt -s inherit_errexit  # Bash disables set -e in command substitution by default; reverse this behavior

ssh_key="$1"
remote="$2"
local="$3"

cleanup () { set +x; }
trap cleanup EXIT
set -x
rsync --progress -av --exclude .DS_Store --exclude .localized --exclude no-sync/ -e "ssh -i $ssh_key" "$remote" "$local"
