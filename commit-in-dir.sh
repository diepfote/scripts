#!/usr/bin/env bash

trap "cd '$PWD'" EXIT

cd "$1"

git status -sb
echo '----------------'

git add .
echo
message="${@:2}"
[ -n "$message" ] && git commit -m "$message" \
  || git commit
echo
echo '----------------'

git status -sb
echo
echo '----------------'

source ~/.sh_functions
git_log -2 --stat
echo '----------------'

sleep 2
git push

