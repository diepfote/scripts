#!/usr/bin/env bash

_yay-all_completions()
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
  completions+=(-h)
  completions+=(--repeat)
  completions+=(--yay-all-no-confirm)
  completions+=(--dry-run)


  case "${prev_word}" in
    *)
      COMPREPLY=($(compgen -W  "$(_print "${completions[@]}")" -- "$cur_word"))
      ;;
  esac

}

complete -F _yay-all_completions 'yay-all'

