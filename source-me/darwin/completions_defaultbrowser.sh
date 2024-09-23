#!/usr/bin/env bash


_defaultbrowser_completions()
{
  local index=$COMP_CWORD
  local cur_word="${COMP_WORDS[$index]}"
  local prev_index=$((index - 1))
  local prev_word="${COMP_WORDS[$prev_index]}"

  local completions=()
  completions+=(firefox)
  completions+=(chrome)
  completions+=(safari)

  COMPREPLY=()
  while IFS='' read -r line; do
    COMPREPLY+=("$line")
  done  < <(compgen -W "$(_print "${completions[@]}")" -- "$cur_word")
  export COMPREPLY
}

complete -F _defaultbrowser_completions defaultbrowser
