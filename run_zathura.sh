#!/usr/bin/env bash

set -o pipefail  # propagate errors
set -u  # exit on undefined
set -e  # exit on non-zero return value
#set -f  # disable globbing/filename expansion
shopt -s failglob  # error on unexpaned globs

[ -z "$*" ] && command=bash || command=$@


ip="$(ifconfig en0  | grep -E 'inet\b' | sed 's#.*inet ##;s# netmask.*##')"
xhost + "$ip"

docker run \
  -v ~/.config/zathura:/root/.config/zathura:ro \
  -v ~/.local/share/zathura:/root/.local/share/zathura:ro \
  -v ~/.bash_history:/root/.bash_history:ro \
  -v /tmp:/tmp:ro \
  -v "$PWD":/pwd:ro \
  -w /pwd \
  -v ~/Documents/books\&documentation:/books:ro \
  -v ~/Downloads:/downloads:ro \
  -v ~/Documents/cheatsheets:/cheatsheets:ro \
  -e DISPLAY="$ip":0 \
  -v /tmp/.X11-unix:/tmp/.X11-unix:ro \
  --security-opt=no-new-privileges \
  --cap-drop=ALL \
  --rm \
  -it \
  --name zathura \
  zathura \
  $command || docker exec -it zathura bash

