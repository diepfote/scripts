#!/usr/bin/env bash

_w-pkg-update_completions()
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
  completions+=(-g)
  completions+=(-n)
  completions+=(--no-lima)
  completions+=(--no-disable-remote-login)
  completions+=(--mac-os-updates-only)

  case "${prev_word}" in
    *)
      COMPREPLY=($(compgen -W  "$(_print "${completions[@]}")" -- "$cur_word"))
      ;;
  esac

}

complete -F _w-pkg-update_completions 'w-pkg-update'
complete -F _w-pkg-update_completions 'pkg-update'

