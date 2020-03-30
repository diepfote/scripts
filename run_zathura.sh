#!/usr/bin/env bash

set -o pipefail  # propagate errors
set -u  # exit on undefined
set -e  # exit on non-zero return value
#set -f  # disable globbing/filename expansion
shopt -s failglob  # error on unexpaned globs

ip="$(ifconfig en0  | grep -E 'inet\b' | sed 's#.*inet ##;s# netmask.*##')"
xhost + "$ip"

docker run -it \
  -v ~/Documents/books\&documentation:/data1:ro \
  -v ~/Downloads:/data2:ro \
  -w /data1 \
  -e DISPLAY="$ip":0 \
  -v /tmp/.X11-unix:/tmp/.X11-unix:ro \
  --security-opt=no-new-privileges \
  --cap-drop=ALL \
  --rm --name zathura \
  zathura:0.1 \
  bash

