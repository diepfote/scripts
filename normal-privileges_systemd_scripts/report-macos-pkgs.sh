#!/usr/bin/env bash

set -o pipefail  # propagate errors
set -u  # exit on undefined
set -e  # exit on non-zero return value
#set -f  # disable globbing/filename expansion
shopt -s failglob  # error on unexpaned globs

cleanup () { set +x; }
trap cleanup EXIT

source ~/Repos/scripts/source-me/common-functions.sh
source ~/Repos/scripts/source-me/darwin/common-functions.sh
_add_to_PATH ~/Repos/python/tools/bin

dir=~/.config/personal/sync-config/mac-os/
[ ! -d "$dir" ] && mkdir "$dir"

remote_path='rsync.net:state/mac-os/'

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

rsync -av --delete  "$dir" "$remote_path"

