#!/usr/bin/env bash

set -o pipefail  # propagate errors
set -u  # exit on undefined
set -e  # exit on non-zero return value
#set -f  # disable globbing/filename expansion
shopt -s failglob  # error on unexpaned globs

content="$1"
file="$2"

set +u
[ -n "$3" ] && line_to_edit="$3" || line_to_edit=1
set -u

if [ "$#" -gt 3 ]; then  # 4th argument signals sudo rights needed
  sudo sed -i "${line_to_edit}s;\$;$content\n;" "$file"
else
  sed -i "${line_to_edit}s;\$;$content\n;" "$file"
fi

