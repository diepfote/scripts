#!/usr/bin/env bash

script_dir="$HOME/Documents/scripts"
source "$script_dir/source-me_common-functions.sh"


_py_complete ()
{
  export DIR_TO_COMPLETE="$HOME/Documents/python"
  _complete_files_and_dirs
}

complete -o filenames -F _py_complete new-python
complete -o filenames -F _py_complete edit-python
complete -o filenames -F _py_complete cp-python
complete -o filenames -F _py_complete mv-python
complete -o filenames -F _py_complete rm-python
complete -o filenames -F _py_complete checkout-python

