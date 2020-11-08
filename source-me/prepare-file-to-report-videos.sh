write_current_videos_to_file()
{
  local dir="$1"
  local filename="$2"

  [ "$(uname)" = Darwin ] && local word=Movies || local word=Videos
  local path_to_search="$HOME/$word"

  find "$path_to_search" -path "$path_to_search/watched" -prune -o -name '*.mp4' -exec sh -c \
    'end="$(echo "{}" | sed "s#.*-##;s#.mp4##")"; python3 -c "import sys; end = sys.argv[1]; name = sys.argv[2]; \
    print(\"- \" + name.split(\"'"$word"'/\")[1]) if len(end) == 11 else print(end=\"\")" "$end" "{}"' \; > "$dir"/"$filename"

  echo >> "$dir"/"$filename"
  [ "$(uname)" = Darwin ] && history | grep -E '^mpv ' | uniq | head -n 15 >> "$dir"/"$filename" || \
                             fish -c 'history | grep -E "^mpv " | uniq | head -n 15' >> "$dir"/"$filename"
}

