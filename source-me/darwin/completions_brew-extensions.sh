#!/usr/bin/env bash

_brew-extensions_completions()
{

  local index=$COMP_CWORD
  local cur_word="${COMP_WORDS[$index]}"
  local prev_index=$((index - 1))
  local prev_word="${COMP_WORDS[$prev_index]}"

  _print () {
    for name in "$@"; do
      echo "$name"
    done
  }

  if [ -z "$formulae" ]; then
    read -r -d '' -a formulae < <(brew list --formulae)
    export formulae
  fi

  COMPREPLY=()
  case "${prev_word}" in
    required-by|formulae-require)
      while IFS='' read -r line; do
        COMPREPLY+=("$line")
      done  < <(compgen -W "$(_print "${formulae[@]}")" -- "$cur_word")
      ;;
    *)
      # call function provided in /usr/local/etc/bash_completion.d/brew
      # default completions
      _brew
    ;;
  esac
}

# TODO patch brew completions to show completions for the following two extensions:
complete -F _brew-extensions_completions 'brew-required-by'
complete -F _brew-extensions_completions 'brew-formulae-require'
# add to default completions for brew
complete -o bashdefault -o default -F _brew-extensions_completions brew

