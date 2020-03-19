#!/usr/bin/env bash

trap "cd $PWD" EXIT

source ~/Documents/scripts/source-me_colors.sh

_arbitrary_command()
{
  dir="$1"
  command_to_run=${@:2}  # skip first arg
  if [ "$(expr substr "$dir" 1 1)" = '#' ]; then
    # ignore commented lines
    exit
  fi

  echo "$dir"
  if [ -d "$dir/.git" ]; then
    cd "$dir"
    $command_to_run
  else
    echo -en "$YELLOW"; echo -en "No .git dir in $dir$NC\n"
  fi
  echo
}

_arbitrary_command $@

