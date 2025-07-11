#!/usr/bin/env bash

source ~/Repos/scripts/source-me/common-functions.sh

_complete_build-container-image ()
{
  export DIR_TO_COMPLETE="$HOME/Repos/dockerfiles"
  export DO_NOT_ADD_SLASH_AFTER_DIR=true
  _complete_files_and_dirs
  unset DO_NOT_ADD_SLASH_AFTER_DIR
}

complete -o filenames -F _complete_build-container-image build-container-image

