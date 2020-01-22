#!/usr/bin/env bash

trap "cd '$PWD'" EXIT

cd "$1"

git add .
echo
git commit -m "${@:2}"
echo

git show --stat
sleep 2

git push

