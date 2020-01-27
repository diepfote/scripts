#!/bin/bash

user=`cut -d : -f 1 /etc/passwd | grep flo | head -n 1`
user_dir=$HOME

error() {
	# redirect the address of file descriptor 1 (stdout) to 
	# the address of file descriptor 2 (stderr) 
	echo -e "\033[1;31mFailed to cd $dir\033[0m" 1>&2
	echo -e "\033[1;31mDid you mount Win_Part?\033[0m" 1>&2
  exit 1
}

download() {
  name=$1
  url=$2
  config_file=$3
  search_term=$4

  # read range for past days from conf file
  day_range_past=$($user_dir/Documents/scripts/read_toml_setting.sh  $config_file  days_past)
  date_to_use=$(date --date="$day_range_past" '+%Y%m%d') 

  dir="$user_dir/Win_Part/Users/Dev/Desktop/$name"
  cd $dir

  if [ "$(pwd)" == "$dir" ]; then

      if [ -z "$search_term" ]; then
        youtube-dl  --write-info-json  --add-metadata  -w  -f best \
          --dateafter "$date_to_use"   $url | grep -E 'Destination|Finished'
        # DEBUG
        #youtube-dl  --write-info-json  --add-metadata  -w  -f best \
          #--dateafter "$date_to_use"   $url
      else
        youtube-dl  --write-info-json  --add-metadata  -w  -f best   \
          --match-title $search_term   --dateafter "$date_to_use"   $url | grep -E 'Destination|Finished'
        # DEBUG
        #youtube-dl  --write-info-json  --add-metadata  -w  -f best   \
          #--match-title $search_term   --dateafter "$date_to_use"   $url
      fi


    echo -e "\033[1;33mEnd $name\033[0m"

  else
    error
  fi
}

download "$@"

