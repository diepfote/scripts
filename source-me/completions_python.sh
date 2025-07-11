#!/usr/bin/env bash

script_dir="$HOME/Repos/scripts"
source "$script_dir/source-me/common-functions.sh"


_py_complete ()
{
  export DIR_TO_COMPLETE="$HOME/Repos/python/tools"
  _complete_files_and_dirs
}

complete -o filenames -F _py_complete new-python
complete -o filenames -F _py_complete edit-python
complete -o filenames -F _py_complete cp-python
complete -o filenames -F _py_complete mv-python
complete -o filenames -F _py_complete rm-python
complete -o filenames -F _py_complete checkout-python
complete -o filenames -F _py_complete status-python
complete -o filenames -F _py_complete diff-python
complete -o filenames -F _py_complete commit-python

