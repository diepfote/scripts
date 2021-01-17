#!/usr/bin/env bash

# nicked from https://mywiki.wooledge.org/BashFAQ/034

_spinner()
{
  text="$1"
  echo -n "$text"

  sp='/-\|'
  printf ' '
  sleep .1
  while true; do
    printf '\b%.1s' "$sp"
    sp=${sp#?}${sp%???}
    sleep .1
  done
}

spinner ()
{
  _spinner "$1" &
}
