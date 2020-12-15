#!/usr/bin/env bash

set -o pipefail  # propagate errors
set -u  # exit on undefined
set -e  # exit on non-zero return value
#set -f  # disable globbing/filename expansion
shopt -s failglob  # error on unexpaned globs


source ~/Documents/scripts/source-me/progressbar.sh
set +u
progressbar
set -u
trap "kill %%" EXIT  # stop progressbar


echo -e '\n--------\npip\n'
#
# bypass virtualenv with `-E`
#
# $ python -E ...
#
for pkg in $(python3 -E -m pip list --user --outdated --format=freeze | grep -v '^\-e' | cut -d = -f 1); do
  python3 -E -m pip install --user "$pkg"  | grep -v 'already satisfied' || true
done

echo -e '\n--------\nruby\n'
gem update --user  # requires gem install rubygems-update


echo -e '\n--------\nnpm\n'
for package in $(npm -g outdated --parseable --depth=0 | cut -d: -f2); do
  # safe upgrade all https://gist.github.com/othiym23/4ac31155da23962afd0e
  npm -g install "$package"
done

echo -e '\n--------\nkrew\n'
kubectl krew update
kubectl krew upgrade  2>&1 |  grep -vE 'already on the newest version|Upgrading plugin' || true

echo -e '\n--------\napm\n'
apm upgrade -c false

echo -e '\n--------\nbrew\n'
echo -en "  $PURPLE"; echo -e "[>] pulling updates...$NC"
brew update

echo -en "  $PURPLE"; echo -e "[>] starting upgrades...$NC"
brew upgrade

