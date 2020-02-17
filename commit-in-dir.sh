#!/usr/bin/env bash

trap "cd '$PWD'" EXIT

cd "$1"

git add .
echo
message="${@:2}"
git commit -m "$message"
echo

source ~/.sh_functions
git_log -1 --stat
sleep 2

git push

