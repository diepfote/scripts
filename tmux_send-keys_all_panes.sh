#!/usr/bin/env bash

echo -e "----------\ncommand: $@"

current_pane_id="$(tmux list-panes -F '#{pane_id} #{pane_active}' | grep ' 1' | cut -d ' ' -f1)"

for pane_id in $(tmux list-panes -F '#{pane_id}'); do

  if [ "$pane_id" != "$current_pane_id" ]; then
    echo "pane id: $pane_id"
    tmux send-keys -t ${pane_id} "$@"
  fi
done

echo -e "\n----------"

