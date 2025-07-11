#!/usr/bin/env bash

script_dir="$HOME/Repos/scripts"
source "$script_dir/source-me/common-functions.sh"

_mutt_complete ()
{
  export DIR_TO_COMPLETE="$HOME/.mutt"
  _complete_files_and_dirs
}

complete -o filenames -F _mutt_complete new-mutt
complete -o filenames -F _mutt_complete edit-mutt
complete -o filenames -F _mutt_complete cp-mutt
complete -o filenames -F _mutt_complete mv-mutt
complete -o filenames -F _mutt_complete rm-mutt
complete -o filenames -F _mutt_complete checkout-mutt
complete -o filenames -F _mutt_complete status-mutt
complete -o filenames -F _mutt_complete diff-mutt
complete -o filenames -F _mutt_complete commit-mutt

