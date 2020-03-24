#!/usr/bin/env bash

trap "popd" EXIT

pushd "$1"

git status -sb
echo -e '\n----------------\n'

git add .
echo
message="${@:2}"
[ -n "$message" ] && git commit -m "$message" \
  || git commit
echo -e '\n----------------\n'

git status -sb
echo -e '\n----------------\n'

source ~/.sh_functions
git l -2 --stat
echo -e '\n----------------\n'

sleep 2
git push

