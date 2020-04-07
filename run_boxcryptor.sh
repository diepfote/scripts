#!/usr/bin/env bash

set -o pipefail  # propagate errors
set -u  # exit on undefined
set -e  # exit on non-zero return value
#set -f  # disable globbing/filename expansion
shopt -s failglob  # error on unexpaned globs

dir=~/Documents/dockerfiles/boxcryptor/data

trap "rm -rf "$dir"/.boxcryptor-internals/{cache,files}" EXIT

podman run -it \
  -v "$dir":/data \
  -v "$dir"/.boxcryptor-internals/:/usr/bin/Boxcryptor/app/.boxcryptor-internals/ \
  -e DISPLAY=$DISPLAY \
  -v /tmp/.X11-unix:/tmp/.X11-unix:ro \
  --security-opt=no-new-privileges \
  --cap-drop=ALL \
  --rm --name boxcryptor \
    localhost/boxcryptor:0.1

