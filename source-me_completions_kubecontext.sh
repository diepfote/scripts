#!/usr/bin/env bash

autocomplete_kubecontext () {
  FILE_EXCHANGE_DIR=~/.kube
  # Set
  IFS=$'\n' tmp=( $(compgen -W "$(ls "$FILE_EXCHANGE_DIR")" -- "${COMP_WORDS[$COMP_CWORD]}" ))
  COMPREPLY=( "${tmp[@]// /\ }" )
}
complete -o default -F autocomplete_kubecontext set_kubecontext

