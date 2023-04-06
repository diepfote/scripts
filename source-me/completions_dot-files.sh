#!/usr/bin/env bash

script_dir="$HOME/Documents/scripts"
source "$script_dir/source-me/common-functions.sh"

_dot-files_complete ()
{
  export DIR_TO_COMPLETE="$HOME/Documents/dot-files"
  _complete_files_and_dirs
}

complete -o filenames -F _dot-files_complete checkout-dot-files
complete -o filenames -F _dot-files_complete status-dot-files
complete -o filenames -F _dot-files_complete diff-dot-files
complete -o filenames -F _dot-files_complete commit-dot-files
