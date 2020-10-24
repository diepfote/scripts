#!/usr/bin/env bash

set -o pipefail  # propagate errors
set -u  # exit on undefined
set -e  # exit on non-zero return value
#set -f  # disable globbing/filename expansion
shopt -s failglob  # error on unexpaned globs

filename="${@:$#}"  # last argument
pattern="${@:(($#-1)):1}"  # next to last argument

temp_dir="$(mktemp -d)"
trap "rm -rf "$temp_dir" " EXIT

temp_filename="$temp_dir"/"$(basename "$filename")"
cp "$filename" "$temp_filename"

# ${@:1:(($#-2))} all except last 2 arguments
sed -i ${@:1:(($#-2))} "$pattern" "$temp_filename"  # all arguments passed to sed

git diff --no-index --word-diff "$filename" "$temp_filename"

