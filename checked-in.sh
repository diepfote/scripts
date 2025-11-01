#!/usr/bin/env bash

# all of these stem from https://www.shellcheck.net/wiki/
set -o pipefail  # propagate errors
set -u  # exit on undefined
set -e  # exit on non-zero return value
#set -f  # disable globbing/filename expansion
shopt -s failglob  # error on unexpaned globs
shopt -s inherit_errexit  # Bash disables set -e in command substitution by default; reverse this behavior


repo_conf="$1"
shift

source ~/Repos/scripts/source-me/posix-compliant-shells.sh


if [ "$repo_conf" = repo.conf ]; then
  find ~/.password-store-* -type l -delete
fi

temp="$(mktemp -d)"
cleanup () {
  rm -r "$temp"
}
trap cleanup EXIT

output="$temp"/out.txt

execute -w 12 --config "$repo_conf" -- git status -sb > "$output"
if [ "$repo_conf" = repo.conf ]; then
  (_link-shared-password-store &)
fi

less -R "$output"


