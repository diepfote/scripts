#!/usr/bin/env bash

# all of these stem from https://www.shellcheck.net/wiki/
set -o pipefail  # propagate errors
set -u  # exit on undefined
set -e  # exit on non-zero return value
#set -f  # disable globbing/filename expansion
shopt -s failglob  # error on unexpaned globs
shopt -s inherit_errexit  # Bash disables set -e in command substitution by default; reverse this behavior


cleanup () { set +x; }
trap cleanup EXIT


source ~/Documents/scripts/source-me/posix-compliant-shells.sh


start="$(read_toml_setting ~/Documents/config/redshift.conf start)"
end="$(read_toml_setting ~/Documents/config/redshift.conf end)"

current_h="$(date +%H)"

ENABLED=''
if [ "$current_h" -ge "$start" ] || [ "$current_h" -le "$end" ]; then
  ENABLED=1
fi

if [ -f /tmp/redshift-on ]; then
  ENABLED=1
elif [ -f /tmp/redshift-off ]; then
  ENABLED=''
fi

if [ -n "$ENABLED" ]; then
  redshift -P -O 4000
else
  redshift -x
fi

