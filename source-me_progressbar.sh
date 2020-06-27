#!/usr/bin/env bash

_progressbar()
{
  text="$1"
  while true; do
    echo -en "$text    \r"
    sleep 0.5

    echo -en "$text .  \r"
    sleep 0.5

    echo -en "$text .. \r"
    sleep 0.5

    echo -en "$text ...\r"
    sleep 0.5

  done
}

progressbar ()
{
  _progressbar "$1" &
}
