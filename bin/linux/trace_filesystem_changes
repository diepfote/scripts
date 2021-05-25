#!/usr/bin/env bash
#
# usage example:
# $ ./trace_filesystem_changes.sh . attrib
#


# an event type such as 'attrib', 'modify' or 'create'
event="$2"
dir_to_watch="$1"

echo -e "[>] starting trace\n  event: '$event'\n  dir: '$(realpath $dir_to_watch)'\n"
while file=$(inotifywait -r -e "$event" --format "%w%f" "$dir_to_watch" 2>/dev/null); do
  echo "$file"
done

