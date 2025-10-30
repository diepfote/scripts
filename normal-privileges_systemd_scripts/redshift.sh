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


source ~/Repos/scripts/source-me/posix-compliant-shells.sh


start_h="$(read-ini-setting ~/.config/personal/redshift.conf start_h)"
start_m="$(read-ini-setting ~/.config/personal/redshift.conf start_m)"
end_h="$(read-ini-setting ~/.config/personal/redshift.conf end_h)"
end_m="$(read-ini-setting ~/.config/personal/redshift.conf end_m)"

current_h="$(date +%H)"
current_m="$(date +%M)"

ENABLED=1
if [ "$current_h" -eq "$start_h" ] && [ "$current_m" -ge "$start_m" ]; then
  echo 1
  ENABLED=1
elif [ "$current_h" -gt "$start_h" ]; then
  echo 2
  ENABLED=1
elif [ "$current_h" -eq "$end_h" ] && [ "$current_m" -ge "$end_m" ]; then
  echo 3
  ENABLED=''
elif [ "$current_h" -gt "$end_h" ]; then
  echo 4
  ENABLED=''
fi


if [ -f /tmp/redshift-on ]; then
  ENABLED=1
elif [ -f /tmp/redshift-off ]; then
  ENABLED=''
fi

if [ -n "$ENABLED" ]; then
  set -x
  redshift -P -O 4000
  set +x
else
  set -x
  redshift -x
  set +x
fi

