#!/usr/bin/env bash

_pkg-update_completions () {
  _yay-all_completions "$@"

  # shellcheck disable=SC1090
  source ~/Documents/scripts/source-me/completions__os-independent-updates.sh
  # shellcheck disable=SC2154
  for compl in "${_OS_INDEPENDENT_UPATES_COMPLETIONS[@]}"; do
    completions+=("$compl")
  done


  _pkg-update_completions-return "$@"
}

_yay-all_completions()
{
  completions=()

  # add yay completion to os independent update script
  source /usr/share/bash-completion/completions/yay
  _yay "$@"
  for compl in "${COMPREPLY[@]}"; do
    completions+=("$compl")
  done

  completions+=(-h)
  completions+=(--repeat)
  completions+=(--list-only)
  completions+=(--yay-all-no-confirm)
  completions+=(--dry-run)

  _pkg-update_completions-return "$@"
}

complete -F _yay-all_completions 'yay-all'

complete -F _pkg-update_completions 'pkg-update'
