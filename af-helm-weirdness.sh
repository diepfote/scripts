#!/usr/bin/env bash

# set -o pipefail  # propagate errors
set -u  # exit on undefined
# set -e  # exit on non-zero return value
#set -f  # disable globbing/filename expansion
shopt -s failglob  # error on unexpaned globs

git status -sb
echo "[.] Pausing for 2 seconds"
sleep 2

git update

[ $# -lt 1 ] && set -- HEAD

git checkout "$1" || git checkout -b "$1"
vault-decrypt
git commit-do-not-push

