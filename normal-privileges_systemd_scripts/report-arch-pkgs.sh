#!/usr/bin/env bash
# shellcheck disable=SC1090

set -o pipefail  # propagate errors
set -u  # exit on undefined
set -e  # exit on non-zero return value
#set -f  # disable globbing/filename expansion
shopt -s failglob  # error on unexpaned globs


cleanup () { set +x; }
trap cleanup EXIT


source ~/Repos/scripts/source-me/posix-compliant-shells.sh


dir=~/.config/personal/sync-config/arch/
[ ! -d "$dir" ] && mkdir -p "$dir"

folder=arch
if [ $# -gt 0 ]; then
  folder="$1"
fi
remote_path="rsync.net:state/$folder/"


# backup pacman database
## to restore move .tar.bz2 file to / and execute "tar -xjvf pacman_database.tar.bz2"
tar -cjf "$dir/pacman_database.tar.bz2" "/var/lib/pacman/local"

pacman -Qqem > "$dir/packages_explicit_external.txt"
pacman -Qqen > "$dir/packages_explicit_internal.txt"
pacman -Qqm  > "$dir/packages_all_external.txt"
pacman -Qqn  > "$dir/packages_all_internal.txt"

set -x
rsync -av --delete "$dir" "$remote_path"

