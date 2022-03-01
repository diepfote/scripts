#!/usr/bin/env bash

set -o pipefail  # propagate errors
set -u  # exit on undefined
set -e  # exit on non-zero return value
#set -f  # disable globbing/filename expansion
shopt -s failglob  # error on unexpaned globs


source ~/Documents/scripts/source-me/common-functions.sh


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

  defaults read -g NSUserKeyEquivalents > "$dir"/nsuserkeyequivalents.txt
  defaults read com.google.Chrome NSUserKeyEquivalents >> "$dir"/nsuserkeyequivalents.txt
  defaults read com.toggl.toggldesktop.TogglDesktop NSUserKeyEquivalents >> "$dir"/nsuserkeyequivalents.txt
  defaults read com.apple.Safari  NSUserKeyEquivalents >> "$dir"/nsuserkeyequivalents.txt
  defaults read com.microsoft.edgemac NSUserKeyEquivalents >> "$dir"/nsuserkeyequivalents.txt
  set +x

  _rclone_verbose_sync_operation --delete-excluded "$dir" "$fastmail_path"

fi

