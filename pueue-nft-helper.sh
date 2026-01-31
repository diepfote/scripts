#!/bin/sh
id="$1"
result="$2"
shift 2

source ~/Repos/scripts/source-me/posix-compliant-shells.sh


if [ "$result" = "Failed" ]; then
  ntf send -t 'nc pq failure' "$(hostname): $id: $*" || echo "$id" > /tmp/pq-last-failed
fi

