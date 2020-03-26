#!/usr/bin/env bash

set -o pipefail  # propagate errors
set -u  # exit on undefined
set -e  # exit on non-zero return value
#set -f  # disable globbing/filename expansion
shopt -s failglob  # error on unexpaned globs


trap "popd" EXIT
pushd ~/Documents/dockerfiles/boxcryptor


download_url="$(curl -s 'https://ptc.secomba.com/api/boxcryptor/linuxPortable/latest' | grep tar | sed -r 's#.*https#https#')"

sed_command='s#.*_##;s#\.tar\.gz##'
upstream_version="$(echo "$download_url" | sed -r "$sed_command")"
file_version="$(ls Boxcryptor* | sed -r "$sed_command")"

set -x
[ "$upstream_version" != "$file_version" ] && rm Boxcryptor*
curl -C - -sO "$download_url"

podman build --no-cache -t boxcryptor:0.1 .
set +x

