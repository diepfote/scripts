#!/usr/bin/env bash

for pane in $(tmux list-panes -F '#{pane_id}'); do
  echo "$pane"
  echo "$@"
  tmux send-keys -t ${pane} "$@"
done

