#!/usr/bin/env bash

set -o pipefail  # propagate errors
set -u  # exit on undefined
set -e  # exit on non-zero return value
#set -f  # disable globbing/filename expansion
shopt -s failglob  # error on unexpaned globs


source ~/Documents/scripts/source-me/{darwin/,}common-functions.sh


dir=~/Documents/misc/mac-os
[ ! -d "$dir" ] && mkdir "$dir"

username="$(read_toml_setting ~/Documents/config/fastmail.conf username)"
fastmail_path='fastmail:'"$username"'.fastmail.com/files/-configs/mac-os'

if _rclone_verbose_sync_operation --delete-excluded "$fastmail_path" "$dir"; then

  set -x

  # generates Brewfile in "$dir"
  # and `-f` overwrites existing file
  (cd "$dir" && brew bundle dump -f)
  brew services > "$dir"/brew-services.txt

  cargo install --list > "$dir"/cargo-pkgs.txt

  # pip freeze but only explicitly installed pkgs
  (cd ~ && pip-chill > "$dir"/python-pkgs.txt)

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

  for nsuserkeyequivalent in "${defaults_nsuserkeyequivalents_to_save[@]}"; do
    set -x
    defaults-dave "$dir" "$nsuserkeyequivalent"
    set +x
  done

  _rclone_verbose_sync_operation --delete-excluded "$dir" "$fastmail_path"

fi

