#!/usr/bin/env bash

autocomplete_scripts () {
  FILE_EXCHANGE_DIR=~/Documents/scripts
  # Set
  IFS=$'\n' tmp=( $(compgen -W "$(ls "$FILE_EXCHANGE_DIR")" -- "${COMP_WORDS[$COMP_CWORD]}" ))
  COMPREPLY=( "${tmp[@]// /\ }" )
}
complete -o default -F autocomplete_scripts new-script
complete -o default -F autocomplete_scripts edit-script
complete -o default -F autocomplete_scripts duplicate-script
complete -o default -F autocomplete_scripts mv-script

