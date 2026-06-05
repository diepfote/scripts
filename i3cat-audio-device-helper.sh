#!/usr/bin/env bash

set -o pipefail  # propagate errors
set -u  # exit on undefined
set -e  # exit on non-zero return value
#set -f  # disable globbing/filename expansion
shopt -s failglob  # error on unexpaned globs

get_volume() {
  pactl get-sink-volume @DEFAULT_SINK@ | awk '{ printf("%s", $5); exit; }'
}

run () {
  local muted
  muted="$(pactl get-sink-mute @DEFAULT_SINK@ | awk '{ printf("%s", $2); exit; }')"

  if [ "$muted" = yes ]; then
    "$HOME/go/bin/i3cat" encode --color '#f91bac' "♪: M($(get_volume))"
  else
    "$HOME/go/bin/i3cat" encode "♪: $(get_volume)"
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

