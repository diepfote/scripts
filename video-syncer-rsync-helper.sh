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

echo "[ssh key] $ssh_key" >&2
echo "[remote] $remote" >&2
echo "[local] $local" >&2
rsync --progress -av --exclude .DS_Store --exclude .localized --exclude no-sync/ -e "ssh -i $ssh_key" "$local" "$remote"
