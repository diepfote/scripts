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

docker image prune -f --filter "until=32h"
docker container prune -f --filter "until=170h"
docker system prune -a -f
