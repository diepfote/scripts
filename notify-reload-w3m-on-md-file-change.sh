#!/usr/bin/env bash

set -o pipefail  # propagate errors
set -u  # exit on undefined
set -e  # exit on non-zero return value
#set -f  # disable globbing/filename expansion
shopt -s failglob  # error on unexpaned globs


_get_w3m_pane_id() {

  local pane_to_reload="$(for pane_pid in $(tmux list-panes -F '#{pane_pid}'); do \
    ps -f --ppid "$pane_pid" \
    | awk '{ print substr($0, index($0,$8))}' \
    | grep /w3m 1>/dev/null && itis=true; \
      set +u; [ "$itis" = true ] \
      && echo "$pane_pid"; itis=false; set -u ; done)"

  tmux list-panes -F "#{pane_pid} #{pane_id}" \
    | grep "$pane_to_reload" | cut -d ' ' -f2
}

watch_dir="$1"

while file=$(inotifywait -e modify --format "%w%f" "$watch_dir"); do

  EXT=$(echo "$file" | \
    python3 -c "filename = input(); print(filename.rsplit('.', 1)[1])")
  if [ "$EXT" = "md" ] || \
     [ -n "$(echo "$file" | grep goutputstream)" ] || \
     [ "$EXT" = "MD" ] || \
     [ "$EXT" = "jpg" ] || \
     [ "$EXT" == "png" ]; then

    tmux send-keys -t "$(_get_w3m_pane_id)" R

  fi

done

