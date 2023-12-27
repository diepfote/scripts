#!/usr/bin/env bash

script_dir="$HOME/Documents/scripts"
source "$script_dir/source-me/common-functions.sh"

_zig_complete ()
{
  export DIR_TO_COMPLETE="$HOME/Documents/zig/tools"
  _complete_files_and_dirs
}

complete -o filenames -F _zig_complete new-zig
complete -o filenames -F _zig_complete edit-zig
complete -o filenames -F _zig_complete cp-zig
complete -o filenames -F _zig_complete mv-zig
complete -o filenames -F _zig_complete rm-zig
complete -o filenames -F _zig_complete checkout-zig
complete -o filenames -F _zig_complete diff-zig
complete -o filenames -F _zig_complete status-zig
complete -o filenames -F _zig_complete commit-zig

