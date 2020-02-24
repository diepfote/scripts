#!/usr/bin/env bash

_complete_password_funcs () {
  FILE_EXCHANGE_DIR=~/Documents/passwds
  # Set
  IFS=$'\n' tmp=( $(compgen -W "$(ls "$FILE_EXCHANGE_DIR")" -- "${COMP_WORDS[$COMP_CWORD]}" ))
  COMPREPLY=( "${tmp[@]// /\ }" )
}
complete -o filenames -F _complete_password_funcs pass_find
complete -o filenames -F _complete_password_funcs view_pass_file
complete -o filenames -F _complete_password_funcs view_pass_files
complete -o filenames -F _complete_password_funcs rm_pass_files
complete -o filenames -F _complete_password_funcs mv_pass_file

