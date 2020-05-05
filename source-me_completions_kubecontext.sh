#!/usr/bin/env bash


_complete_openstackctx () {
  local FILE_EXCHANGE_DIR=~/.openstack
  _complete_context_files "$FILE_EXCHANGE_DIR"
}

_complete_kubektx () {
  local FILE_EXCHANGE_DIR=~/.kube
  _complete_context_files "$FILE_EXCHANGE_DIR"
}

_complete_context_files () {
  local FILE_EXCHANGE_DIR="$1"
  # Set
  IFS=$'\n' tmp=( $(compgen -W "$(ls "$FILE_EXCHANGE_DIR")" -- "${COMP_WORDS[$COMP_CWORD]}" ))
  COMPREPLY=( "${tmp[@]// /\ }" )
}

complete -o filenames -F _complete_kubektx set_kubecontext
complete -o filenames -F _complete_openstackctx set_openstack_context

