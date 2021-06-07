#!/usr/bin/env bash

# nicked from https://mywiki.wooledge.org/BashFAQ/034

_spinner()
{
  text="$1"
  echo -n "$text"
  sleep .5

  # shellcheck disable=SC2001
  spaces="$(echo "$text" | sed 's#.# #g')"
  echo -en "\r$spaces"
  spinner_items=('⣾' '⣽' '⣻' '⢿' '⡿' '⣟' '⣯' '⣷')
  while true; do
    for item in "${spinner_items[@]}"; do
      sleep .1
      echo -ne "\r\b$item"
    done
  done
}

spinner ()
{
  _spinner "$1" &
}
