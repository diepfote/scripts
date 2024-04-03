#!/usr/bin/env bash

_yabai_completions()
{
  COMPREPLY=()
  index=$COMP_CWORD
  local cur_word="${COMP_WORDS[$index]}"

  completions=()
  completions+=(--start-service)
  completions+=(--stop-service)

  COMPREPLY=($(compgen -W  "$(_print "${completions[@]}")" -- "$cur_word"))
}

complete -F _yabai_completions 'yabai'

