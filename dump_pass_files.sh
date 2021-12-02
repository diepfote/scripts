#!/usr/bin/env bash

user=$(cut -d : -f 1 /etc/passwd | grep flo | head -n 1)
user_dir=/home/$user  

script_dir="$user_dir"/Documents/scripts
pass_dir="$user_dir"/Documents/passwds
temp_dir=$(mktemp -d)

if [ ! -d "$script_dir" ]; then
  script_dir="$user_dir"/Docs/scripts
  pass_dir="$user_dir"/Dokumente/passwds
fi

pass=$("$script_dir"/read_pass.sh)

for files in $(find "$pass_dir" -iname "*.gpg")
do 
  for file in $(echo -e "$files") 
  do
    #echo "$pass" | gpg -d --batch --passphrase-fd 0 "$file" > "$temp_dir"/"$(basename "$file" | sed 's/.gpg//')"
    echo $pass | gpg --cipher-algo AES256 -d --batch --passphrase-fd 0 $file > $temp_dir/$(basename $file | sed 's/.gpg//')
    echo -e "\n----------------------\n"
  done
done

echo Dumped files to "$temp_dir"
cd "$temp_dir"

