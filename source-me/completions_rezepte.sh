#!/usr/bin/env bash

# script_dir="$HOME/Repos/scripts"
# source "$script_dir/source-me/common-functions.sh"

_cheats-rezepte_complete ()
{
  export DIR_TO_COMPLETE="$HOME/Repos/rezepte"
  _complete_files_and_dirs
}

complete -o filenames -F _cheats-rezepte_complete rezepte

