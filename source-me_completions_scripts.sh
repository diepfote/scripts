#!/usr/bin/env bash

_complete_scripts () {
  FILE_EXCHANGE_DIR=~/Documents/scripts
  # Set
  IFS=$'\n' tmp=( $(compgen -W "$(ls "$FILE_EXCHANGE_DIR")" -- "${COMP_WORDS[$COMP_CWORD]}" ))
  COMPREPLY=( "${tmp[@]// /\ }" )
}
complete -o filenames -F _complete_scripts new-script
complete -o filenames -F _complete_scripts edit-script
complete -o filenames -F _complete_scripts duplicate-script
complete -o filenames -F _complete_scripts mv-script
complete -o filenames -F _complete_scripts rm-script

