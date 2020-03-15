#!/usr/bin/env bash

script_dir="$HOME/Documents/scripts"
source "$script_dir/source-me_common-functions.sh"
export DIR_TO_COMPLETE="$script_dir"

complete -o filenames -F _complete_files_and_dirs new-script
complete -o filenames -F _complete_files_and_dirs edit-script
complete -o filenames -F _complete_files_and_dirs duplicate-script
complete -o filenames -F _complete_files_and_dirs mv-script
complete -o filenames -F _complete_files_and_dirs rm-script

