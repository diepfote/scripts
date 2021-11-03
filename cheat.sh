#!/usr/bin/env bash

set -o pipefail  # propagate errors
set -u  # exit on undefined
set -e  # exit on non-zero return value
#set -f  # disable globbing/filename expansion
shopt -s failglob  # error on unexpaned globs


find_path="$1"
shift

# snatched from https://stackoverflow.com/a/11396899
declare -A map
for name in pdf png jpg gif; do
  map["$name"]=1
done

_help() {
cat <<EOF
USAGE: cheat [--edit|--find|--grep] [FILENAME]

Displays files in less, image viewer, pdf viewer or browser by default.
If \`edit\` is specified, the file will be openend for editing in vim (if not one of $(for key in "${!map[@]}"; do echo -n "$key, "; done)html.
If \`find\` is specified, find will be run in the cheatsheets dir.
If \`grep\` is specified, grep will be run in the cheatsheets dir.

COMMANDS:
  edit
  find OPTIONS  FIND_STRING   Run find in cheatsheets DIR
    $ cheat find -name '*find*'
    + find $find_path -name '*find*'

  grep OPTIONS  GREP_STRING   Run grep in cheatsheets DIR
    $ cheat grep -n ' find '
    + grep -n ' find ' --color=always -r $find_path

EOF
}

if [ $# -eq 0 ]; then
  _help
  exit
fi

# Parse arguments
positional_args=()
command=('lessc')
while [ $# -gt 0 ]; do
key="$1"
  case "$key" in
    edit)
    command=('nvim')
    shift
    ;;

    find)
    command=('find')
    shift
    ;;

    grep)
    command=('grep')
    shift
    ;;

    -h|--help)
    _help
    exit 0
    ;;

    *) # unknown option
    positional_args+=("$1") # save in an array for later
    shift
    ;;
  esac
done
set -- "${positional_args[@]}"


# shellcheck disable=SC1090
source ~/Documents/scripts/source-me/common-functions.sh
# shellcheck disable=SC1090
source ~/Documents/scripts/source-me/posix-compliant-shells.sh

if [ "$(uname)" = Darwin ]; then
  base_temp_dir="$(mktemp -d)"
else
  base_temp_dir=~/Downloads

  # shellcheck disable=SC1090
  source ~/Documents/scripts/source-me/linux/posix-compliant-shells.sh
fi


if [ "${command[0]}" = 'find' ]; then
  set -x
  "${command[@]}" "$find_path" "$@"
  set +x
  exit
elif [ "${command[0]}" = 'grep' ]; then
  set -x
  "${command[@]}" "$@" --color=always -r "$find_path"
  set +x
  exit
fi


filename="${*:$#}"  # last argument
file="$find_path"/"$filename"
# shellcheck disable=SC2001
extension="$(echo "$filename" | sed 's#.*\.##')"

use_system_open=""
set +u
if [[ ${map["$extension"]} ]] ; then
  use_system_open="true"
fi
set -u

if [ -n "$use_system_open" ]; then
  if [ "$(uname)" = Darwin ]; then
    open "$file"
  else
    xdg-open "$file"
  fi

elif [ "$extension" = html ] && [ "${command[0]}" != 'nvim' ] ; then
  temp_file="$base_temp_dir"/"$filename"
  cp "$file" "$temp_file"  # for firejail on Linux

  call_browser "$temp_file"
else
  if [ $# -eq 0 ]; then
    set -- "$find_path"
  else
    set -- "${@:1:$(($#-1))}"   # all except last = filename
  fi

  "${command[@]}" "$@" "$file"
fi
