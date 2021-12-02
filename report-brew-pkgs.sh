#!/usr/bin/env bash

set -o pipefail  # propagate errors
set -u  # exit on undefined
set -e  # exit on non-zero return value
#set -f  # disable globbing/filename expansion
shopt -s failglob  # error on unexpaned globs

dir=~/Documents/misc/mac-os
[ ! -d "$dir" ] && mkdir "$dir"

#brew info --installed --json | jq .[].name | sed 's#"##g' > ~/Documents/misc/mac-os/brew-pkgs.txt
brew list > "$dir"/brew-pkgs.txt
brew cask list > "$dir"/brew-cask-pkgs.txt

username="$(read_toml_setting ~/Documents/config/fastmail.conf username)"
rclone sync --delete-excluded -v "$dir" 'fastmail:'$username'.fastmail.com/files/-configs/mac-os'

