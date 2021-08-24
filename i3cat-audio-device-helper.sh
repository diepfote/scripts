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

  awk -F '[][]' '/%/ { print $2 ; exit }' <(amixer sget "$device")
}


# muted = off
# unmuted = on
get_device_on_off () {
  awk -F"[][]" '/%/ { print $4 ; exit }' <(amixer sget "$device")
}

while true; do
  if [ "$(get_device_on_off "$device")" = off ]; then
    i3cat encode --color '#f91bac' "$(get_volume "$device")"
  else
    i3cat encode "$(get_volume "$device")"
  fi
done

