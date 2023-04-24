#!/usr/bin/env bash

set -o pipefail  # propagate errors
set -u  # exit on undefined
set -e  # exit on non-zero return value
#set -f  # disable globbing/filename expansion
shopt -s failglob  # error on unexpaned globs

interface="$1"

get_last_handshake () {
  local interface
  interface="$1"
  set +e
  if ! sudo wg show "$interface" latest-handshakes | awk '{ print $2 }' | head -n1; then
    # default timestamp for last handshake
    # ... never
    echo 0
  fi
  set -e
}

get_timestamp_x_seconds_ago () {
  local cur_timestamp x_seconds_ago
  x_seconds_ago="$1"
  cur_timestamp="$(date '+%s')"
  echo $(( cur_timestamp - x_seconds_ago ))
}

run () {
  local last_handshake max_seconds_since_handshake min_since
  last_handshake="$(get_last_handshake "$interface")"
  max_seconds_since_handshake=180

  if [ "$last_handshake" -lt "$(get_timestamp_x_seconds_ago "$max_seconds_since_handshake")" ]; then
    min_since=$((max_seconds_since_handshake / 60))
    i3cat encode --color '#ff0000' "$interface:>${min_since}min"
  else
    i3cat encode --color '#00dc00' "$interface"
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

