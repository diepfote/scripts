#!/usr/bin/env bash

set -o pipefail  # propagate errors
set -u  # exit on undefined
set -e  # exit on non-zero return value
#set -f  # disable globbing/filename expansion
shopt -s failglob  # error on unexpaned globs

echo -e "second argument: ${@:2:1}"  # ${@:which_arg_to_start_on:how_long_to_continue}

#array=( "$@" )
#unset "array[${#array[@]}-1]"    # Removes last element -- also see: help unset
#set "$array"
last_arg="${@:$#}"
set -- "${@:1:$(($#-1))}"  # all except last

echo $@

echo "$last_arg"

