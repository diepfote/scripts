#!/usr/bin/env bash

# such as 'attrib', 'modify'
event="$2"
dir_to_watch="$1"

echo -e "[>] starting trace\n  event: '$event'\n  dir: '$(realpath $dir_to_watch)'\n"
while file=$(inotifywait -e "$event" --format "%w%f" "$dir_to_watch" 2>/dev/null); do
  echo "$file"
done

