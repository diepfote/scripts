#!/usr/bin/env bash

autocomplete_for_different_directory () {
  FILE_EXCHANGE_DIR=~/Documents/passwds
  # Set
  IFS=$'\n' tmp=( $(compgen -W "$(ls "$FILE_EXCHANGE_DIR")" -- "${COMP_WORDS[$COMP_CWORD]}" ))
  COMPREPLY=( "${tmp[@]// /\ }" )
}
complete -o default -F autocomplete_for_different_directory pass_find
complete -o default -F autocomplete_for_different_directory view_pass_file
complete -o default -F autocomplete_for_different_directory view_pass_files
complete -o default -F autocomplete_for_different_directory rm_pass_files
complete -o default -F autocomplete_for_different_directory mv_pass_file

