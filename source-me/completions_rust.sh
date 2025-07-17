#!/usr/bin/env bash

script_dir="$HOME/Repos/scripts"
source "$script_dir/source-me/common-functions.sh"

_rust_complete ()
{
  export DIR_TO_COMPLETE="$HOME/Repos/rust/tools"
  _complete_files_and_dirs
}

complete -o filenames -F _rust_complete new-rust
complete -o filenames -F _rust_complete edit-rust
complete -o filenames -F _rust_complete cp-rust
complete -o filenames -F _rust_complete mv-rust
complete -o filenames -F _rust_complete rm-rust
complete -o filenames -F _rust_complete checkout-rust
complete -o filenames -F _rust_complete diff-rust
complete -o filenames -F _rust_complete status-rust
complete -o filenames -F _rust_complete commit-rust

