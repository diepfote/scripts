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

  awk -F '[][]' '/%/ { printf "%s", $2 ; exit }' <(amixer sget "$device")
}


# muted = off
# unmuted = on
get_device_on_off () {
  if awk -F"[][]" '/%/ { print $0; exit }' <(amixer sget "$device") | grep -- '\[off\]'  >/dev/null 2>&1; then
    echo off
  else
    echo on
  fi
}


run () {
  if [ "$(get_device_on_off "$device")" = off ]; then
    i3cat encode --color '#f91bac' "♪: muted ($(get_volume "$device"))"
  else
    i3cat encode "♪: $(get_volume "$device")"
  fi

  sleep infinity &
  # DO NOT PUT ANYTHING INBETWEEN THESE LINES.
  # NOT EVEN SAVING PID AND RUNNING ANOTHER PROCESS
  # like echo to print the PID.
  #
  # OTHERWISE YOU WILL BREAK THIS SCRIPTS SIGNAL
  # HANDLING CAPABILITIES.
  #
  # Tests can be done via
  #
  # pactl set-sink-volume @DEFAULT_SINK@ +1% && ps -ef | grep -E 'i3cat-audio-device-helper.sh [A-Z]+' | grep -v grep | awk '{ print $2 }' | xargs kill -SIGUSR1  # very broad (will kill vim if this file is open)
  #
  wait "$!"
}

sigusr1 () {
  run
}

trap sigusr1 USR1

run

