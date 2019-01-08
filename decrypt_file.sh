#!/usr/bin/env bash

pass="$1"
file="$2"

if [ "$(uname -a | grep Ubuntu)" == "" ]; then
echo "$pass" | gpg --no-symkey-cache --cipher-algo AES256 -d --batch --passphrase-fd 0 "$file" 2>/dev/null
else
echo "$pass" | gpg --cipher-algo AES256 -d --batch --passphrase-fd 0 "$file" 2>/dev/null
fi

