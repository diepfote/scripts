#!/usr/bin/env bash

aliases_file=~/.sh_functions
# clear file
echo -n > "$aliases_file"

for files in "$(find ~/.config/fish/functions/ -name "*.fish")"
do 
  echo "----------------------"
  echo "[>] generating sh functions for fish shell functions"
  echo

  for file in $(echo -e $files) 
  do
    basename_no_ext="$(basename "$file" | sed 's/\.[^.]*$//')"
    echo "$basename_no_ext"
    echo 'function '"$basename_no_ext"' { fish -c "'"$basename_no_ext"' $@"'\; } >> "$aliases_file"
  done
  echo -e "----------------------\n"
done

