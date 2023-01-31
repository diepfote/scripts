
#!/usr/bin/env bash

source "$HOME/Documents/scripts/source-me/common-functions.sh"

_etc_complete ()
{
  export DIR_TO_COMPLETE="/etc"
  _complete_files_and_dirs
}

complete -o filenames -F _etc_complete diff-etc-files
