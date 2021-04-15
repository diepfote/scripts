#!/bin/sh

watch_dir="$1"

while inotifywait --timefmt '%F %T' --format "%T  %e %w%f" $watch_dir; do
  echo 1>/dev/null
done

