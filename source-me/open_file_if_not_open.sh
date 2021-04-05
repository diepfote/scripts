open_file_if_not_open ()
{
  local filename="$1"

  if [ -z "$(ps -ef | grep -v grep | grep "$(basename "$filename")")" ]; then
    xdg-open "$filename"  # xdg-open should be a function already
  fi
}

