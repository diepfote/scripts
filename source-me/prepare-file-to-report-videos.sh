#!/usr/bin/env bash


write_current_videos_to_file() {
  local filename="$1"
  local hist_file=~/.bash_history

  if [ "$(uname)" = Darwin ]; then
    local word=Movies
  else
    local word=Videos
  fi
  local path_to_search="$HOME/$word"

  find "$path_to_search" \
    -path "$path_to_search/jonathan blow" -prune -o \
    -path "$path_to_search/totalbiscuit" -prune -o \
    -path "$path_to_search/audio-only/tgs_podcasts" -prune -o \
    -path "$path_to_search/watched" -prune -o \
    -path "$path_to_search/***REMOVED***" -prune -o \
    -iregex '.*\.\(mp4\|m4a\)' | sed "s#.*$word/##" > "$filename"

  echo >> "$filename"
  grep -E "^mpv " "$hist_file" | sort | uniq | tail -n 15 >> "$filename"
}

