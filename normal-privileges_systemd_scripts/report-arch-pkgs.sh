#!/usr/bin/env bash
# shellcheck disable=SC1090

set -o pipefail  # propagate errors
set -u  # exit on undefined
set -e  # exit on non-zero return value
#set -f  # disable globbing/filename expansion
shopt -s failglob  # error on unexpaned globs


source ~/Repos/scripts/source-me/posix-compliant-shells.sh


dir=~/.config/personal/sync-config/arch
[ ! -d "$dir" ] && mkdir -p "$dir"

username="$(read_toml_setting ~/.config/personal/fastmail.conf username)"
remote_path='fastmail:'"$username"'.fastmail.com/files/-config/arch'
# remote_path='proton:-configs/arch'

if rclone sync --delete-excluded "$remote_path" "$dir"; then

  # backup pacman database
  ## to restore move .tar.bz2 file to / and execute "tar -xjvf pacman_database.tar.bz2"
  tar -cjf "$dir/pacman_database.tar.bz2" "/var/lib/pacman/local"

  pacman -Qqem > "$dir/packages_explicit_external.txt"
  pacman -Qqen > "$dir/packages_explicit_internal.txt"
  pacman -Qqm  > "$dir/packages_all_external.txt"
  pacman -Qqn  > "$dir/packages_all_internal.txt"

  rclone sync --delete-excluded "$dir" "$remote_path"

fi

