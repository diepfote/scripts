#!/usr/bin/env bash

aliases_file=~/.sh_functions
# clear file
echo -n > "$aliases_file"

for files in "$(find ~/.config/fish/functions/ -name "*.fish")"
do 
  for file in $(echo -e $files) 
  do
    basename_no_ext="$(basename "$file" | sed 's/\.[^.]*$//')"
    echo -e "----------------------\n$basename_no_ext"
    #echo 'alias '"$basename_no_ext"'="fish -c "'"$basename_no_ext"' $@""' >> "$aliases_file"
    echo 'function '"$basename_no_ext"' { fish -c "'"$basename_no_ext"' $@"'\; } >> "$aliases_file"
    #function tail_ls { ls -l "$1" | tail; }
    echo -e "\n----------------------\n"
  done
done

