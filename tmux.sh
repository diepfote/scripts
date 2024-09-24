#!/usr/bin/env bash

# DEBUG
# cleanup () { set +x; }
# trap cleanup EXIT
# set -x

tmux_bin=/opt/homebrew/bin/tmux
if [ "$(uname)" = Linux ]; then
  tmux_bin=/usr/bin/tmux
fi

"$tmux_bin" "$@"
# run plain bash if we exit tmux by detaching or starting tmux fails
TMUX_FAILURE=true bash
