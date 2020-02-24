#!/usr/bin/env bash

_complete_kubektx () {
  FILE_EXCHANGE_DIR=~/.kube
  # Set
  IFS=$'\n' tmp=( $(compgen -W "$(ls "$FILE_EXCHANGE_DIR")" -- "${COMP_WORDS[$COMP_CWORD]}" ))
  COMPREPLY=( "${tmp[@]// /\ }" )
}
complete -o filenames -F _complete_kubektx set_kubecontext

