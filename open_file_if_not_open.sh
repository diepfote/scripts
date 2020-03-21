open_file_if_not_open ()
{
  filename="$1"

  if [ -z "$(ps -ef | grep -v grep | grep "$(basename "$filename")")" ]; then
    xdg-open "$filename"  1>/dev/null 2>/dev/null
  fi
}

