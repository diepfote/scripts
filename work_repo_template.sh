#!/usr/bin/env bash

function arbitrary_command
{
  dir="$1"
  if [[ ${dir:0:1} == '#' ]]; then
    # ignore commented lines
    exit
  fi
 

  echo "$dir"
  if [ -d $dir/.git ]; then
    cd $dir 
    # execute command (skipping first parameter)
    "${@:2}"
  else
    echo -en "$YELLOW"; echo -en "No .git dir in $dir$NC\n"
  fi
  echo
}

RED='\033[1;31m'
YELLOW='\033[1;33m'
GREEN='\033[1;32m'
NC='\033[0m'

arbitrary_command $@

