#!/usr/bin/env bash

script_dir="$HOME/Repos/scripts"
source "$script_dir/source-me/common-functions.sh"

_view_dirs_complete ()
{
  export DIR_TO_COMPLETE="$HOME/Documents"
  _complete_files_and_dirs
}

complete -o filenames -F _view_dirs_complete view_dirs
