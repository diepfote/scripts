#!/usr/bin/env bash

set -o pipefail  # propagate errors
set -u  # exit on undefined
set -e  # exit on non-zero return value
#set -f  # disable globbing/filename expansion
shopt -s failglob  # error on unexpaned globs

temp_dir="$(mktemp -d)"
new_file="$temp_dir/$(basename "$1")"
cp "$1" "$new_file"

# trap "rm -rf "$temp_dir" " EXIT

sed -ri 's#\((.*)\)#"$(\1)"##' "$new_file"  # subshell
sed -ri 's#set ([A-Za-z_]+) #\1=##g' "$new_file"  # set statements
sed -ri 's#(if[^]]+ \])#\1; then#' "$new_file"  # if statements
sed -ri 's#\$argv\[([0-9]+)\]#"$\1"#' "$new_file"  # argv
sed -ri 's#(\s+)end#\1fi#' "$new_file"  # end
# TODO for loop

echo "$new_file"
git diff --no-index "$1" "$new_file"
