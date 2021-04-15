#!/usr/bin/env bash

#
# originally taken from https://github.com/jessfraz/dotfiles/blob/master/test.sh
#


set -o pipefail  # propagate errors
set -u  # exit on undefined
set -e  # exit on non-zero return value
#set -f  # disable globbing/filename expansion
shopt -s failglob  # error on unexpaned globs

ERRORS=()

# find all executables and run `shellcheck`
for f in $(find "$1" -type f -not -path '*.git*' -not -name "yubitouch.sh" | sort -u); do
  if file "$f" | grep --quiet shell; then
    {
      shellcheck "$f" && echo "[OK]: successfully linted $f"
    } || {
      # add to errors
      ERRORS+=("$f")
    }
  fi
done

if [ ${#ERRORS[@]} -eq 0 ]; then
  echo "No errors, hooray"
else
  echo "These files failed shellcheck: ${ERRORS[*]}"
  exit 1
fi

