#!/usr/bin/env bash

_complete_mac_apps () {
  FILE_EXCHANGE_DIR=/Applications
  # Set
  IFS=$'\n' tmp=( $(compgen -W "$(ls "$FILE_EXCHANGE_DIR")" -- "${COMP_WORDS[$COMP_CWORD]}" ))
  COMPREPLY=( "${tmp[@]// /\ }" )
}
complete -o filenames -F _complete_mac_apps open_mac-os_app

