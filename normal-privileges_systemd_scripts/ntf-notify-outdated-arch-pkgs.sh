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
_add_to_PATH ~/Repos/scripts/bin/linux/

# set -x

f=/tmp/pkgs-to-update
prev_chk_file=/tmp/pkgs-to-update-chksum
prev_chk="$(head -n 1 "$prev_chk_file" || true)"

pacman --sudo -Sy
yay -Qu > "$f" || true
# echo -e 'openssl test\nasdf pkg\nmiau' > "$f" || true
cur_chk="$(sha256sum "$f" | awk '{ print $1 }' )"


if [ "$cur_chk" = "$prev_chk" ]; then
  exit
fi


echo -n "$cur_chk" > "$prev_chk_file"


if [ "$(wc -l "$f" | awk '{ print $1 }')" -gt 0 ]; then
  ntf send -t 'nc pkgs to update' "$(cat "$f")"
fi  

