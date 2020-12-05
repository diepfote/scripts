#!/usr/bin/env bash

set -o pipefail  # propagate errors
set -u  # exit on undefined
set -e  # exit on non-zero return value
#set -f  # disable globbing/filename expansion
shopt -s failglob  # error on unexpaned globs

sed -ri 's#\((.*)\)#"$(\1)"##' "$1"
sed -ri 's#set ([A-Za-z_]+) #\1=##g' "$1"
sed -ri 's#(if[^]]+ \])#\1; then#' "$1"
sed -ri 's#\$argv\[([0-9]+)\]#"$\1"#' "$1"
sed -ri 's#(\s+)end#\1fi#' "$1"

~/Documents/scripts/work_repo_template.sh ~/.config/fish/functions git diff --word-diff
