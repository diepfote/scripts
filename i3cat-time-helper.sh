#!/usr/bin/env bash

set -o pipefail  # propagate errors
set -u  # exit on undefined
set -e  # exit on non-zero return value
#set -f  # disable globbing/filename expansion
shopt -s failglob  # error on unexpaned globs

TZ="$1"

print_time() {
  "$HOME/go/bin/i3cat" encode < <(TZ="$TZ" date -d '4 minutes' "+%a %m/%d %H:%M%:::z" | tr -d '\n')
}


run () {
  print_time

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
  # ps -ef | grep -F 'i3cat-time-helper.sh' | grep -v grep | awk '{ print $2 }' | xargs kill -SIGUSR1  # very broad (will kill vim if this file is open)
  #
  wait "$!"
}

sigusr1 () {
  run
}

trap sigusr1 USR1

run

