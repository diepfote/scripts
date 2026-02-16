#!/usr/bin/env bash

set -o pipefail  # propagate errors
set -u  # exit on undefined
set -e  # exit on non-zero return value
#set -f  # disable globbing/filename expansion
shopt -s failglob  # error on unexpaned globs

voc="$(~/.bin/read-ini-setting ~/.config/personal/services.conf voc flashcard-gen)"
flash="$(~/.bin/read-ini-setting ~/.config/personal/services.conf flashcards flashcard-gen)"



# regenerate flashcards
for f in "$voc"/*.txt; do echo ---; echo "$f:"; ~/Repos/python/tools/bin/flashcard-gen "$f" > "$flash"/"$(basename "$f" | sed -r 's#.txt$#.md#')"; done 

# sync only active cards
for f in ~/flashcards/*.md; do cp "$flash"/"$(basename "$f")" ~/flashcards/; done 

