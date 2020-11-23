#!/usr/bin/env bash

script_dir="$HOME/Documents/scripts"
source "$script_dir/source-me/common-functions.sh"

_vimscript_complete ()
{
  export DIR_TO_COMPLETE="$HOME/.vim"
  _complete_files_and_dirs
}

complete -o filenames -F _vimscript_complete new-vim
complete -o filenames -F _vimscript_complete edit-vim
complete -o filenames -F _vimscript_complete cp-vim
complete -o filenames -F _vimscript_complete mv-vim
complete -o filenames -F _vimscript_complete rm-vim
complete -o filenames -F _vimscript_complete checkout-vim

