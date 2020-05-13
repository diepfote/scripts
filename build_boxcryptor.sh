#!/usr/bin/env bash

set -o pipefail  # propagate errors
set -u  # exit on undefined
set -e  # exit on non-zero return value
#set -f  # disable globbing/filename expansion
#shopt -s failglob  # error on unexpaned globs


trap "popd" EXIT
pushd ~/Documents/dockerfiles/boxcryptor


download_url="$(curl -s 'https://ptc.secomba.com/api/boxcryptor/linuxPortable/latest' | grep tar | sed -r 's#.*https#https#')"

sed_command='s#.*_##;s#\.tar\.gz##'
set -x
upstream_version="$(echo "$download_url" | sed -r "$sed_command")"
set +x

shopt -u failglob  # unset error on unexpaned globs
set -x
file_version="$(ls Boxcryptor* | sed -r "$sed_command" || true )"
set +x
shopt -s failglob  # error on unexpaned globs

if [ "$upstream_version" != "$file_version" ] || [ "$1" = -f ]; then
  set -x
  shopt -u failglob
  rm -f Boxcryptor*
  shopt -s failglob

  curl -sO "$download_url"

  podman build --squash --no-cache -t boxcryptor:0.1 .
  set +x
fi

