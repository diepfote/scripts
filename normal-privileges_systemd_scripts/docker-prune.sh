#!/usr/bin/env bash

set -o pipefail  # propagate errors
set -u  # exit on undefined
set -e  # exit on non-zero return value
#set -f  # disable globbing/filename expansion
shopt -s failglob  # error on unexpaned globs

if [ "$(uname)" = Darwin ]; then
  set +u
  set +e
  export BASH_SOURCE_IT=true
  source ~/.bashrc
  set -e
  set -u
fi

docker container prune -f --filter "until=48h"
# much force | very prune | no rest for the wicked
docker images --filter "until=48h" -q | xargs -n 1 docker rmi -f

