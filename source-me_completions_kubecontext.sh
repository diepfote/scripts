#!/usr/bin/env bash

autocomplete_for_different_directory () {
  FILE_EXCHANGE_DIR=~/.kube
  # Set
  IFS=$'\n' tmp=( $(compgen -W "$(ls "$FILE_EXCHANGE_DIR")" -- "${COMP_WORDS[$COMP_CWORD]}" ))
  COMPREPLY=( "${tmp[@]// /\ }" )
}
complete -o default -F autocomplete_for_different_directory set_kubecontext

