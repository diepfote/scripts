#!/usr/bin/env bash

script_dir="$HOME/Documents/scripts"
source "$script_dir/source-me/common-functions.sh"

_cheats_complete ()
{
  export DIR_TO_COMPLETE="$HOME/Documents/cheatsheets"
  _complete_files_and_dirs
}

complete -o filenames -F _cheats_complete cheat
complete -o filenames -F _cheats_complete cp-cheat
complete -o filenames -F _cheats_complete mv-cheat
complete -o filenames -F _cheats_complete rm-cheat

