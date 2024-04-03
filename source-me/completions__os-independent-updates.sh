#!/usr/bin/env bash

__os-independent-updates_completions ()
{
  if [ "$1" = --non-interactive-use ]; then
    shift
  else
    unset completions
  fi

  COMPREPLY=()
  index=$COMP_CWORD
  local cur_word="${COMP_WORDS[$index]}"
  prev_index=$((index - 1))
  local prev_word="${COMP_WORDS[$prev_index]}"

  completions=("${completions[@]}")

  completions+=(--skip-rust-cargo)
  completions+=(--skip-vim-updates)

  case "${prev_word}" in
    *)
      COMPREPLY=($(compgen -W  "$(_print "${completions[@]}")" -- "$cur_word"))
      ;;
  esac

}

complete -F __os-independent-updates_completions _os-independent-updates
