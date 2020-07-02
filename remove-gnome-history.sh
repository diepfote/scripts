#!/usr/bin/env bash

file_dir=~/.local/share
set -x
find "$file_dir" -maxdepth 1 -type f -name 'recently-used.xbel*' -delete
set +x


