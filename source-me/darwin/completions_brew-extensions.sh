#!/usr/bin/env bash

_brew-extensions_completions()
{
  _print () {
    for name in "$@"; do
      echo "$name"
    done
  }

  index=$COMP_CWORD
  local cur_word="${COMP_WORDS[$index]}"
  prev_index=$((index - 1))
  local prev_word="${COMP_WORDS[$prev_index]}"

  if [ -z "$formulae" ]; then
    read -r -d '' -a formulae < <(brew list --formulae)
    export formulae
  fi

  COMPREPLY=()
  case "${prev_word}" in
    *)
      while IFS='' read -r line; do
        COMPREPLY+=("$line")
      done  < <(compgen -W "$(_print "${formulae[@]}")" -- "$cur_word")
      ;;
  esac
}

# TODO patch brew completions to show completions for the following two extensions:
complete -F _brew-extensions_completions 'brew-required-by'
complete -F _brew-extensions_completions 'brew-formulae-require'

