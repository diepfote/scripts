#!/usr/bin/env bash

# DEBUG
# cleanup () { set +x; }
# trap cleanup EXIT
# set -x

tmux_bin=/opt/homebrew/bin/tmux
if [ "$(uname)" = Linux ]; then
  tmux_bin=/usr/bin/tmux
fi

"$tmux_bin" "$@" || TMUX_FAILURE=true bash
