#!/usr/bin/env bash

set -o pipefail  # propagate errors
set -u  # exit on undefined
set -e  # exit on non-zero return value
#set -f  # disable globbing/filename expansion
shopt -s failglob  # error on unexpaned globs

trap "rm -rf ~/Documents/boxcryptor_container/data/.boxcryptor-internals/cache ~/Documents/boxcryptor_container/data/.boxcryptor-internals/files" EXIT

podman run -it \
  -v ~/Documents/boxcryptor_container/data/:/data \
  -v ~/Documents/boxcryptor_container/data/.boxcryptor-internals/:/usr/bin/Boxcryptor/app/.boxcryptor-internals/ \
  -e DISPLAY=$DISPLAY \
  -v /tmp/.X11-unix:/tmp/.X11-unix:ro \
  --security-opt=no-new-privileges \
  --cap-drop=ALL \
  --rm --name boxcryptor \
    localhost/boxcryptor:0.1

