#!/usr/bin/env bash

set -o pipefail  # propagate errors
set -u  # exit on undefined
set -e  # exit on non-zero return value
#set -f  # disable globbing/filename expansion
shopt -s failglob  # error on unexpaned globs


source ~/Documents/scripts/source-me/common-functions.sh
source ~/Documents/scripts/source-me/darwin/common-functions.sh
_add_to_PATH ~/Documents/python/tools/bin

dir=~/Documents/misc/mac-os
[ ! -d "$dir" ] && mkdir "$dir"

remote_path='proton:-configs/mac-os'

if rclone sync --checksum --delete-excluded "$remote_path" "$dir"; then

  set -x

  # generates Brewfile in "$dir"
  # and `-f` overwrites existing file
  (cd "$dir" && brew bundle dump -f)
  brew services > "$dir"/brew-services.txt

  cargo install --list > "$dir"/cargo-pkgs.txt

  # pip freeze but only explicitly installed pkgs
  (cd ~ && pip-chill > "$dir"/python-pkgs.txt)

  pipx list --include-injected > "$dir"/pipx-list.txt

  kubectl krew list > "$dir"/krew-pkgs.txt
  set +x

  defaults_nsuserkeyequivalents_to_save=()
  defaults_nsuserequivalents_to_save+=(-g)
  defaults_nsuserequivalents_to_save+=(com.google.Chrome)
  defaults_nsuserequivalents_to_save+=(com.toggl.toggldesktop.TogglDesktop)
  defaults_nsuserequivalents_to_save+=(com.apple.Safari)
  defaults_nsuserequivalents_to_save+=(com.apple.TextEdit)
  defaults_nsuserequivalents_to_save+=(com.microsoft.edgemac)
  defaults_nsuserequivalents_to_save+=(com.microsoft.word)
  defaults_nsuserequivalents_to_save+=(com.microsoft.excel)

  for nsuserkeyequivalent in "${defaults_nsuserkeyequivalents_to_save[@]}"; do
    set -x
    defaults-dave "$dir" "$nsuserkeyequivalent"  || true
    set +x
  done

  rclone sync --checksum --delete-excluded "$dir" "$remote_path"

fi

