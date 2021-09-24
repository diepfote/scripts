#!/usr/bin/env bash
# complete -o filenames -F _complete_kubektx set-kubecontext

script_dir="$HOME/Documents/scripts"
source "$script_dir/source-me/common-functions.sh"

_set-kubecontext_complete ()
{
  export DIR_TO_COMPLETE="$HOME/.kube"
  _complete_files_and_dirs
}

complete -o filenames -F _set-kubecontext_complete set-kubecontext

