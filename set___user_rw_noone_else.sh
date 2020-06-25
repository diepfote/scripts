#!/usr/bin/env bash

set -e
set -o pipefail
set -u

dir="$1"

if [ -z "$dir" ]; then
  dir=.
fi

find "$dir" -type f -exec sh -c 'chmod -f 600 "$0"' {} \; || true  # do not return non-zero return code
find "$dir" -type d -exec sh -c 'chmod -f 700 "$0"' {} \; || true

