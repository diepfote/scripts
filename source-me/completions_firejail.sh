#!/usr/bin/env bash

script_dir="$HOME/Repos/scripts"
source "$script_dir/source-me/common-functions.sh"

_firejail_complete ()
{
  export DIR_TO_COMPLETE="$HOME/.config/firejail"
  _complete_files_and_dirs
}

complete -o filenames -F _firejail_complete new-firejail
complete -o filenames -F _firejail_complete edit-firejail
complete -o filenames -F _firejail_complete cp-firejail
complete -o filenames -F _firejail_complete mv-firejail
complete -o filenames -F _firejail_complete rm-firejail
complete -o filenames -F _firejail_complete checkout-firejail
complete -o filenames -F _firejail_complete commit-firejail

