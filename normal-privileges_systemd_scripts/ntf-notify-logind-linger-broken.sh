#!/usr/bin/env bash
# shellcheck disable=SC1090


dir=/var/lib/systemd/linger
if ! ls "$dir"; then
  ntf send -t "$(hostname) logind linger" "Directory does not exist or is inaccessible $dir"
fi

