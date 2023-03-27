#!/usr/bin/env bash

_pkg-update_completions() {
  _w-pkg-update_completions "$@"

  # shellcheck disable=SC1090
  source ~/Documents/scripts/source-me/completions__os-independent-updates.sh
  # shellcheck disable=SC2154
  for compl in "${_OS_INDEPENDENT_UPATES_COMPLETIONS[@]}"; do
    completions+=("$compl")
  done

  _pkg-update_completions-return "$@"
}

_w-pkg-update_completions()
{

  completions=()
  completions+=(-h)
  completions+=(-g)
  completions+=(-r)
  completions+=(--reinstall-xcode)
  completions+=(--no-lima)
  completions+=(--no-disable-remote-login)
  completions+=(--no-mac-os-updates)
  completions+=(--no-update-repos)
  completions+=(--mac-os-updates-only)

  _pkg-update_completions-return "$@"

}

_pkg-update_completions-return () {
  _print() {
    for elem in "$@"; do
      echo "$elem"
    done
  }

  COMPREPLY=()
  index=$COMP_CWORD
  local cur_word="${COMP_WORDS[$index]}"
  prev_index=$((index - 1))
  local prev_word="${COMP_WORDS[$prev_index]}"

  case "${prev_word}" in
    *)
      COMPREPLY=($(compgen -W  "$(_print "${completions[@]}")" -- "$cur_word"))
      ;;
  esac
}

complete -F _w-pkg-update_completions 'w-pkg-update'
complete -F _pkg-update_completions 'pkg-update'

