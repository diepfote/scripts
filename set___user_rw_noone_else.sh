#!/usr/bin/env bash

dir="$1"

if [ -z "$dir" ]; then
  dir=.
fi

find "$dir" -type f -exec sh -c 'chmod -f 600 "{}"' \; || true  # do not return non-zero return code
find "$dir" -type d -exec sh -c 'chmod -f 700 "{}"' \; || true 

