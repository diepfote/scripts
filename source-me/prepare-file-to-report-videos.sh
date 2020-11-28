write_current_videos_to_file()
{
  local dir="$1"
  local filename="$2"
  local hist_file=~/.bash_history

  if [ "$(uname)" = Darwin ]; then
    local word=Movies
  else
    local word=Videos
  fi
  local path_to_search="$HOME/$word"

  find "$path_to_search" -path "$path_to_search/watched" -prune -o -name '*.mp4' -exec sh -c \
    'end="$(echo "{}" | sed "s#.*-##;s#.mp4##")"; python3 -c "import sys; end = sys.argv[1]; name = sys.argv[2]; \
    print(\"- \" + name.split(\"'"$word"'/\")[1]) if len(end) == 11 else print(end=\"\")" "$end" "{}"' \; > "$dir"/"$filename"

  echo >> "$dir"/"$filename"
  grep -E "^mpv " "$hist_file" | uniq | tail -n 15 >> "$dir"/"$filename"
}

