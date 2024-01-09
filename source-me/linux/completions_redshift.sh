#!/usr/bin/env bash

_redshift_completions()
{
  COMPREPLY=()
  index=$COMP_CWORD
  local cur_word="${COMP_WORDS[$index]}"
  prev_index=$((index - 1))
  local prev_word="${COMP_WORDS[$prev_index]}"


  COMPREPLY=()
  case "${prev_word}" in
    *)
      while IFS='' read -r line; do
        COMPREPLY+=("$line")
      done < <(compgen -W "$(echo -e 'on\noff\nreset')" -- "$cur_word")
      ;;
  esac

}

complete -F _redshift_completions redshift
