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

file_dir=~/.local/share

RED='\033[1;31m'
GREEN='\033[1;32m'
NC='\033[0m'

files=$(find $file_dir -maxdepth 1 -type f -name 'recently-used.xbel*')
# DEBUG
#echo -e "$files"

echo -e "----------------------\nRemoving gedit history files\n"
for file in $(echo -e $files) 
do
  
  rm $file
  check_error "$?" rm $RED $NC 
  
  echo -en "$GREEN"; echo -en "Successfully removed $(basename $file)!$NC"; echo

done
echo -e "\n----------------------\n"

