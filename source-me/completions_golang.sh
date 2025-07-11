#!/usr/bin/env bash

script_dir="$HOME/Repos/scripts"
source "$script_dir/source-me/common-functions.sh"

_golang_complete ()
{
  export DIR_TO_COMPLETE="$HOME/Repos/golang/tools"
  _complete_files_and_dirs
}

complete -o filenames -F _golang_complete new-go
complete -o filenames -F _golang_complete edit-go
complete -o filenames -F _golang_complete cp-go
complete -o filenames -F _golang_complete mv-go
complete -o filenames -F _golang_complete rm-go
complete -o filenames -F _golang_complete checkout-go
complete -o filenames -F _golang_complete diff-go
complete -o filenames -F _golang_complete status-go
complete -o filenames -F _golang_complete commit-go

