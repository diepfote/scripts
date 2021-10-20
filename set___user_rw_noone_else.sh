#!/usr/bin/env bash

set -e
set -o pipefail
set -u

if [ -z "$1" ]; then
  set -- .
fi

set -x
find "$@" -type f -exec sh -c 'chmod -f 600 "$0"' {} \; || true  # do not return non-zero return code
find "$@" -type d -exec sh -c 'chmod -f 700 "$0"' {} \; || true
set +x
echo
