#!/usr/bin/env bash

autocomplete_funcs () {
  FILE_EXCHANGE_DIR=~/.config/fish/functions
  # Set
  IFS=$'\n' tmp=( $(compgen -W "$(ls "$FILE_EXCHANGE_DIR")" -- "${COMP_WORDS[$COMP_CWORD]}" ))
  COMPREPLY=( "${tmp[@]// /\ }" )
}
complete -o default -F autocomplete_funcs new-function
complete -o default -F autocomplete_funcs edit-function
complete -o default -F autocomplete_funcs duplicate-function
complete -o default -F autocomplete_funcs mv-function

