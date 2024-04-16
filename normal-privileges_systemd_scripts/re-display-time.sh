#!/usr/bin/env bash

# all of these stem from https://www.shellcheck.net/wiki/
set -o pipefail  # propagate errors
set -u  # exit on undefined
set -e  # exit on non-zero return value
#set -f  # disable globbing/filename expansion
shopt -s failglob  # error on unexpaned globs
shopt -s inherit_errexit  # Bash disables set -e in command substitution by default; reverse this behavior

ps -ef | grep -F 'i3cat-time-helper.sh' | grep -v grep | awk '{ print $2 }' | xargs kill -SIGUSR1  # very broad (will kill vim if this file is open)

