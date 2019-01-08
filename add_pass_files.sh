#!/usr/bin/env bash

function check_error
{
  error_code="$1"
  where=$2
  RED=$3
  NC=$4
  if [ "$error_code" != 0 ]; then
    echo -e "${RED}Error at $where! EC: $error_code${NC}" 1>&2
    exit $error_code
  fi
}

file_dir=$1

user=$(cut -d : -f 1 /etc/passwd | grep flo)
user_dir=/home/$user  

script_dir=$user_dir/Documents/scripts
pass_dir=$user_dir/Documents/passwds

if [ ! -d $script_dir ]; then
  script_dir=$user_dir/Docs/scripts
  pass_dir=$user_dir/Dokumente/passwds
fi

pass=$($script_dir/read_pass.sh)
pass_second=$($script_dir/read_pass.sh)



RED='\033[1;31m'
GREEN='\033[1;32m'
NC='\033[0m'

if [ "$pass" != "$pass_second" ]; then
  echo -en "$RED"; echo -en "Passwords do not match!$NC"; echo
else

  files=$(find $file_dir -maxdepth 1 -type f)
  # DEBUG
  #echo -e "$files"

  for file in $(echo -e $files) 
  do
    echo -e "----------------------\nAdding $(basename $file)\n"
    
    echo $pass | gpg -c --batch --passphrase-fd 0 $file
    #echo $pass | gpg --cipher-algo AES256 -c --batch --passphrase-fd 0 $file
    check_error "$?" gpg $RED $NC

    mv $file.gpg $pass_dir
    check_error "$?" mv $RED $NC 
    chmod 600 $pass_dir/*
    check_error "$?" chmod $RED $NC 

    rm $file
    check_error "$?" rm $RED $NC 
    
    echo -en "$GREEN"; echo -en "Successfully added $(basename $file)!$NC"; echo

    echo -e "\n----------------------\n"
  done
fi

