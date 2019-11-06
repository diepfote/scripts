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

progressbar "emit some $PURPLE text$NC" &
read  # run progressbar until <Enter> is pressed

kill %%  # kill last job

