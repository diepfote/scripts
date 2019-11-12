#!/usr/bin/env bash

progressbar()
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

