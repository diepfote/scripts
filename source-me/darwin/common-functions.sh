#!/usr/bin/env bash



# export all NSUserKeyEquivalents for an Application/or global ones to a file
defaults-export-nsuserkeyequivalents () {
  _defaults-helper-nsuserkeyequivalents read "$1" "$2"
}


# TODO check why this does not work.
# Values show up if you `defaults read` them.
# They do not show up in the GUI settings app.
# Shortcuts do not work after setting them this way.
#
# import all NSUserKeyEquivalents for an Application/or global ones from a file
#
# Usage:
#
# import by predefinend name
# $ defaults-import-nsuserkeyequivalents <path-to-dir> com.apple.Safari
# $ defaults-import-nsuserkeyequivalents <path-to-dir> -g
# $ defaults-import-nsuserkeyequivalents . com.apple.Safari
# $ defaults-import-nsuserkeyequivalents . -g
#
# import by custom filename
# $ defaults-import-nsuserkeyequivalents asdf.txt -g
#
#
defaults-import-nsuserkeyequivalents () {
  _defaults-helper-nsuserkeyequivalents write "$1" "$2"
}

_defaults-helper-nsuserkeyequivalents () {
  local where dir filename key_value awk_line

  op="$1"
  # leave order as it is
  where=("$3")
  dir_or_filename="$2"

  if [ -f "$dir_or_filename" ]; then
    dir=.
    filename="$dir_or_filename"
  else
    dir="$dir_or_filename"

    if [ "${where[0]}" = -g ]; then
      filename=Global-NSUserKeyEquivalents.txt
    else
      filename="${where[0]}"-NSUserKeyEquivalents.txt
    fi
  fi

  if [ "$op" = read ]; then
    defaults "$op" "${where[0]}" NSUserKeyEquivalents > "$dir"/"$filename"
  elif [ "$op" = write ]; then
    while read -r line; do

      key_value=()
      while read -r awk_line; do
        key_value+=("$awk_line")
      done < <(_defaults-get-key-value-pairs-nsuserkeyequivalents "$line")

      set -x
      defaults "$op" "${where[0]}" NSUserKeyEquivalents -dict-add "${key_value[0]}" "$(printf '%b\n' "${key_value[1]}" )"
      set +x

    done < <(_defaults-read-nsuserkeyequivalents-file "$dir/$filename")

  fi
}

_defaults-read-nsuserkeyequivalents-file () {
  local line

  while read -r line; do
    # no curly brace at the start of the line
    if [[ "$line" =~ ^[^\\{\\}] ]]; then
      # echo "[DEBUG] $line" >&2
      echo "$line"
    fi
  done < "$1"
}

_defaults-get-key-value-pairs-nsuserkeyequivalents () {
  local key_value awk_line
  key_value=()

  while read -r awk_line; do
    key_value+=("$awk_line")
  done < <(awk -F ' = ' '{ printf("%s\n%s\n", $1, $2) }' < <(echo "$1"))
  echo "${key_value[0]}"
  echo "${key_value[1]}" | sed -r 's#;$##'
}
