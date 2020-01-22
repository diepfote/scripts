#!/usr/bin/env bash

trap "cd '$PWD'" EXIT

cd "$1"

git add .
echo
git commit -m "${@:2}"
echo

source ~/.sh_functions
git_log -1 --stat
sleep 2

git push

