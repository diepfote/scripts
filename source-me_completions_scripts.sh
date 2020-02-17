#!/usr/bin/env bash

autocomplete_for_different_directory () {
  FILE_EXCHANGE_DIR=~/Documents/scripts
  # Set
  IFS=$'\n' tmp=( $(compgen -W "$(ls "$FILE_EXCHANGE_DIR")" -- "${COMP_WORDS[$COMP_CWORD]}" ))
  COMPREPLY=( "${tmp[@]// /\ }" )
}
complete -o default -F autocomplete_for_different_directory new-script
complete -o default -F autocomplete_for_different_directory edit-script
complete -o default -F autocomplete_for_different_directory duplicate-script
complete -o default -F autocomplete_for_different_directory mv-script

