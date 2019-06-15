#!/usr/bin/env bash

: '
This is a
multi line
comment
'

# single line comment

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
#cat "$DIR"/comments.sh
cat "$BASH_SOURCE"

