#!/usr/bin/env bash

set -o pipefail  # propagate errors
set -u  # exit on undefined
set -e  # exit on non-zero return value
#set -f  # disable globbing/filename expansion
shopt -s failglob  # error on unexpaned globs


trap "popd" EXIT
pushd ~/Documents/dockerfiles/zathura

set -x
docker build --no-cache -t zathura:0.1 .
set +x

