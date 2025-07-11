#!/usr/bin/env bash

script_dir="$HOME/Repos/scripts"
source "$script_dir/source-me/common-functions.sh"

_dockerfiles_complete ()
{
  export DIR_TO_COMPLETE="$HOME/Repos/dockerfiles"
  _complete_files_and_dirs
}

complete -o filenames -F _dockerfiles_complete new-docker
complete -o filenames -F _dockerfiles_complete edit-docker
complete -o filenames -F _dockerfiles_complete cp-docker
complete -o filenames -F _dockerfiles_complete mv-docker
complete -o filenames -F _dockerfiles_complete rm-docker
complete -o filenames -F _dockerfiles_complete checkout-docker
complete -o filenames -F _dockerfiles_complete status-docker
complete -o filenames -F _dockerfiles_complete diff-docker
complete -o filenames -F _dockerfiles_complete commit-docker

