#!/usr/bin/env bash

set -o pipefail  # propagate errors
set -u  # exit on undefined
set -e  # exit on non-zero return value
#set -f  # disable globbing/filename expansion
shopt -s failglob  # error on unexpaned globs

[ -z "$*" ] && command=bash || command=$@

if [ "$(uname)" = Darwin ]; then
  set +e  # start container even if the interface does not have an ip assigned
  ip="$(ifconfig en0  | grep -E 'inet\b' | sed 's#.*inet ##;s# netmask.*##')"
  xhost + "$ip"
  set -e
  DISPLAY="$ip":0
else
  DISPLAY="$DISPLAY"
fi

docker run \
  -u build-user \
  -v ~/.bash_history:/build/.bash_history:ro \
  --network=host \
  -e DISPLAY="$DISPLAY" \
  -v /tmp/.X11-unix:/tmp/.X11-unix:ro \
  --rm \
  -it \
  --name yay \
  yay \
  $command || docker exec -it yay bash  # try exec on failure

