#!/usr/bin/env bash

set -o pipefail  # propagate errors
set -u  # exit on undefined
set -e  # exit on non-zero return value
#set -f  # disable globbing/filename expansion
shopt -s failglob  # error on unexpaned globs


trap "popd" EXIT

pushd ~/Documents/boxcryptor_container

set -x
podman build --no-cache -t boxcryptor:0.1 .
set +x

