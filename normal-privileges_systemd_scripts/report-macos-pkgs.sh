#!/usr/bin/env bash

set -o pipefail  # propagate errors
set -u  # exit on undefined
set -e  # exit on non-zero return value
#set -f  # disable globbing/filename expansion
shopt -s failglob  # error on unexpaned globs

cleanup () { set +x; }
trap cleanup EXIT

source ~/Repos/scripts/source-me/posix-compliant-shells.sh

dir=~/.config/personal/sync-config/mac-os/
[ ! -d "$dir" ] && mkdir "$dir"
username="$(read-ini-setting ~/.config/personal/fastmail.conf username)"
remote_path='fastmail:'"$username"'.fastmail.com/files/state/mac-os'

set -x

# generates Brewfile in "$dir"
# and `-f` overwrites existing file
(cd "$dir" && brew bundle dump -f)
brew services > "$dir"/brew-services.txt

cargo install --list > "$dir"/cargo-pkgs.txt

# pip freeze but only explicitly installed pkgs
(cp ~/pyproject.toml "$dir"/pyproject.toml)

uv tool list --show-python --show-extras --show-with --show-version-specifiers > "$dir"/uv-tool-list.txt

kubectl krew list > "$dir"/krew-pkgs.txt
set +x

defaults_nsuserkeyequivalents_to_save=()
defaults_nsuserkeyequivalents_to_save+=(NSGlobalDomain)
defaults_nsuserkeyequivalents_to_save+=(com.apple.Finder)
defaults_nsuserkeyequivalents_to_save+=(com.apple.Safari)
defaults_nsuserkeyequivalents_to_save+=(com.apple.TextEdit)
defaults_nsuserkeyequivalents_to_save+=(com.microsoft.word)
defaults_nsuserkeyequivalents_to_save+=(com.microsoft.excel)
defaults_nsuserkeyequivalents_to_save+=(org.whispersystems.signal-desktop-beta)
defaults_nsuserkeyequivalents_to_save+=(org.whispersystems.signal-desktop)

# https://github.com/koenrh/deft
# NOTE: be sure to remove all backspaces (U+0008) with customshortcuts first
#      (https://www.houdah.com/customShortcuts?ref=CustomShortcuts)
for key in "${defaults_nsuserkeyequivalents_to_save[@]}"; do
  set -x
  deft dump -exclude "*"  -include NSUserKeyEquivalents "$key" > "$dir/nsuserkeyequivalents/$key.yaml"
  set +x
done

set -x
rclone sync --delete-excluded "$dir" "$remote_path"
