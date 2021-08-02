#!/usr/bin/env bash

script_dir="$HOME/Documents/scripts"
source "$script_dir/source-me/common-functions.sh"

_scripts_complete ()
{
  export DIR_TO_COMPLETE="$HOME/Documents/scripts"
  _complete_files_and_dirs
}

complete -o filenames -F _scripts_complete new-script
complete -o filenames -F _scripts_complete edit-script
complete -o filenames -F _scripts_complete cp-script
complete -o filenames -F _scripts_complete mv-script
complete -o filenames -F _scripts_complete rm-script
complete -o filenames -F _scripts_complete checkout-script

