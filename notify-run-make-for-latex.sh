#!/usr/bin/env bash

set -o pipefail  # propagate errors
set -u  # exit on undefined
set -e  # exit on non-zero return value
#set -f  # disable globbing/filename expansion
shopt -s failglob  # error on unexpaned globs


filename="$(head -n 1 Makefile  | cut -d '=' -f2)".pdf
watch_dir="$1"

while file=$(inotifywait -e modify --format "%w%f" "$watch_dir"); do
  EXT=$(echo "$file" | cut -d '.' -f2)
  if [ "$EXT" = "tex" ] || \
     [ -n "$(echo "$file" | grep goutputstream)" ] || \
     [ "$EXT" = "jpg" ] || \
     [ "$EXT" == "png" ]; then
    sleep 0.1

    if [ ! -f "$filename" ]; then
      make
    fi

    make

  fi
done

