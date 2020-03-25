#!/usr/bin/env bash

_complete_funcs () {
  FILE_EXCHANGE_DIR=~/.config/fish/functions
  # Set
  IFS=$'\n' tmp=( $(compgen -W "$(ls "$FILE_EXCHANGE_DIR")" -- "${COMP_WORDS[$COMP_CWORD]}" ))
  COMPREPLY=( "${tmp[@]// /\ }" )
}
complete -o filenames -F _complete_funcs new-function
complete -o filenames -F _complete_funcs edit-function
complete -o filenames -F _complete_funcs cp-function
complete -o filenames -F _complete_funcs mv-function
complete -o filenames -F _complete_funcs rm-function

