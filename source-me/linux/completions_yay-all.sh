#!/usr/bin/env bash

_pkg-update_completions () {
  _yay-all_completions "$@"

  __os-independent-updates_completions --non-interactive-use "$@"

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
  completions+=(--no-fetch)
  completions+=(--repeat)
  completions+=(--list-only)
  completions+=(--dry-run)

  _pkg-update_completions-return "$@"
}

complete -F _yay-all_completions 'yay-all'

complete -F _pkg-update_completions 'pkg-update'
