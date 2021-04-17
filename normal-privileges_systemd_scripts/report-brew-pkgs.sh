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
if rclone sync --exclude .DS_Store --delete-excluded -v 'fastmail:'"$username"'.fastmail.com/files/-configs/mac-os' "$dir"; then

  #brew info --installed --json | jq .[].name | sed 's#"##g' > ~/Documents/misc/mac-os/brew-pkgs.txt
  brew list --formula > "$dir"/brew-pkgs.txt
  brew list --cask > "$dir"/brew-cask-pkgs.txt
  kubectl krew list > "$dir"/krew-pkgs.txt

  defaults read -g NSUserKeyEquivalents > "$dir"/nsuserkeyequivalents.txt
  defaults read com.google.Chrome NSUserKeyEquivalents >> "$dir"/nsuserkeyequivalents.txt
  defaults read com.toggl.toggldesktop.TogglDesktop NSUserKeyEquivalents >> "$dir"/nsuserkeyequivalents.txt
  defaults read com.apple.Safari  NSUserKeyEquivalents >> "$dir"/nsuserkeyequivalents.txt
  defaults read com.microsoft.edgemac NSUserKeyEquivalents >> "$dir"/nsuserkeyequivalents.txt

  rclone sync --exclude .DS_Store --delete-excluded -v "$dir" 'fastmail:'"$username"'.fastmail.com/files/-configs/mac-os'

fi

