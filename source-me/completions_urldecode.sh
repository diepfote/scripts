#!/usr/bin/env bash

_urldecode_completions()
{
  COMPREPLY=()
  index=$COMP_CWORD
  local cur_word="${COMP_WORDS[$index]}"
  prev_index=$((index - 1))
  local prev_word="${COMP_WORDS[$prev_index]}"

  _print() {
    for elem in "$@"; do
      echo "$elem"
    done
  }
  completions=()
  completions+=(--oauth2)


  case "${prev_word}" in
    *)
      COMPREPLY=($(compgen -W  "$(_print "${completions[@]}")" -- "$cur_word"))
      ;;
  esac

}

complete -F _urldecode_completions 'urldecode'

