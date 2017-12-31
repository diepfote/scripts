#!/bin/bash

echo -e "\033[1;33mboxcryptor update start\033[0m"

user=`cut -d : -f 1 /etc/passwd | grep flo`
user_dir=/home/$user

boxcryptor_location=$user_dir/Desktop/boxcr

current_boxcryptor_ver_with_ext=$(curl -sI https://ptc.secomba.com/api/boxcryptor/linuxPortable/latest | grep Location | cut -d ':' -f3 | cut -d '/' -f7 | sed "s/\r//" 2>/dev/null)

last_in_filesystem=$(find $boxcryptor_location -printf "%TY-%Tm-%Td %TT %p\n" | sort -nr | grep tar.gz | head -1 | cut -d ' ' -f3 | cut -d '/' -f6 2>/dev/null)
  
if [ "$last_in_filesystem" == "$current_boxcryptor_ver_with_ext" ]; then
  echo -e "\033[1;32mNo new boxcryptor version.\033[0m"

  start_of_version=29
  version_length=10
  echo -e Current verion is: "\033[1;32m`expr substr $last_in_filesystem $start_of_version $version_length`\033[0m"
else
  if [ -z "$current_boxcryptor_ver_with_ext" ]; then
    echo -e "\033[1;31mNo internet connection?\033[0m" 1>&2
    exit 1
  fi

  echo -e "\033[1;33mDownloading new version: $current_boxcryptor_ver_with_ext\033[0m"
  curl -sL https://ptc.secomba.com/api/boxcryptor/linuxPortable/latest -o $boxcryptor_location/$current_boxcryptor_ver_with_ext

  temp=$boxcryptor_location/temp
  mkdir $temp
  cp $boxcryptor_location/$current_boxcryptor_ver_with_ext $temp
 
  ## safely extract to current dir 
  tar -xf $boxcryptor_location/$current_boxcryptor_ver_with_ext -C $temp
  
  # remove old files
  rm -rf $boxcryptor_location/Boxcryptor/runtime
  rm -rf $boxcryptor_location/Boxcryptor/exec
  rm $boxcryptor_location/Boxcryptor/app/*
  rm $boxcryptor_location/README.txt
  rm $boxcryptor_location/Boxcryptor_Portable.sh
  
  # delete oldest tar.gz version (3rd .tar.gz file is deleted - sorted by newest)
  rm $boxcryptor_location/$(find $boxcryptor_location -printf "%TY-%Tm-%Td %TT %p\n" | sort -nr | grep tar.gz | sed -n 4p | cut -d '/' -f6 2>/dev/null) 

  mv $temp/README.txt $boxcryptor_location
  mv $temp/Boxcryptor_Portable.sh $boxcryptor_location

  mv $temp/Boxcryptor/app/* $boxcryptor_location/Boxcryptor/app/
  mv $temp/Boxcryptor/exec $boxcryptor_location/Boxcryptor
  mv $temp/Boxcryptor/runtime $boxcryptor_location/Boxcryptor

  rm -rf $temp
fi

echo -e "\033[1;33mboxcryptor update end\033[0m"

