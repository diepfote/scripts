#!/usr/bin/env bash

set -o pipefail  # propagate errors
set -u  # exit on undefined
set -e  # exit on non-zero return value
#set -f  # disable globbing/filename expansion
shopt -s failglob  # error on unexpaned globs


temp="$(mktemp -d)"
base_name="$(basename "$1")"
temp_file="$temp"/"$base_name"

trap "rm -r $temp" EXIT

#
# Sorting the history  https://unix.stackexchange.com/questions/48713/how-can-i-remove-duplicates-in-my-bash-history-preserving-order/48716#48716
#
# This command works like sort|uniq, but keeps the lines in place
#
nl "$1" | sed -r 's#\s+$##'  |sort -k 2|uniq -f 1|sort -n|cut -f 2 > "$temp_file"
#
# Basically, prepends to each line its number. After sort|uniq-ing, all lines are sorted back according to their original order (using the line number field) and the line number field is removed from the lines.
#
# This solution has the flaw that it is undefined which representative of a class of equal lines will make it in the output and therefore its position in the final output is undefined. However, if the latest representative should be chosen you can sort the input by a second key:
#
# nl "$1" |sort -k2 -k 1,1nr|uniq -f1|sort -n|cut -f2

ls -al "$1" "$temp_file"

mv "$temp_file" "$1"
