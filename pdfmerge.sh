#!/usr/bin/env bash

set -o pipefail  # propagate errors
set -u  # exit on undefined
set -e  # exit on non-zero return value
#set -f  # disable globbing/filename expansion
shopt -s failglob  # error on unexpaned globs

array=( $@ )
len=${#array[@]}
last=${array[$len-1]}
_args=${array[@]:0:$len-1}

gs -dBATCH -dNOPAUSE -q -sDEVICE=pdfwrite -sOutputFile="$last" $_args

