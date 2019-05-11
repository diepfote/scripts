#!/usr/bin/env bash

dir="$1"

if [ -z "$dir" ]; then
  dir=.
fi

find "$dir" -type f -exec sh -c 'chmod 600 "{}"' \;
find "$dir" -type d -exec sh -c 'chmod 700 "{}"' \;

