#!/usr/bin/env bash

set -o pipefail  # propagate errors
set -u  # exit on undefined
set -e  # exit on non-zero return value
#set -f  # disable globbing/filename expansion
shopt -s failglob  # error on unexpaned globs

device="$1"

get_volume() {
  local device
  device="$1"

  awk -F '[][]' '/%/ { print $2 }' <(amixer sget "$device") | head -n 1
}

while true; do
  if [ "$(awk -F"[][]" '/%/ { print $4 }' <(amixer sget "$device"))" = off ]; then
    i3cat encode --color '#f91bac' "$(get_volume "$device")"
  else
    i3cat encode "$(get_volume "$device")"
  fi
done

