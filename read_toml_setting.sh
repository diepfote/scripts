#!/usr/bin/env bash
#echo -e "$(cat $1 | grep -v "^#.*")"
echo -e "$(cat $1 | grep -v "^#.*" | grep "$2" | sed 's/[A-Za-z0-9_-]*=//' | head -n 1)"

