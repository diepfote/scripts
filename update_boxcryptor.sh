#!/bin/bash

cd /home/flo/Desktop/boxcr/

current_boxcryptor=$(curl -sI https://ptc.secomba.com/api/boxcryptor/linuxPortable/latest | grep Location | cut -d ':' -f3 | cut -d '/' -f7 | sed "s/\r//")

last_in_filesystem=$(find -printf "%TY-%Tm-%Td %TT %p\n" | sort -nr | grep tar.gz | head -1 | cut -d ' ' -f3 | cut -d '/' -f2) 

if echo $last_in_filesystem | grep $current_boxcryptor 1>/dev/null; then
  echo
  echo -e "\033[1;32mNo new boxcryptor version.\033[0m"

  start_of_version=29
  version_length=10
  echo -e Current verion is: "\033[1;32m`expr substr $last_in_filesystem $start_of_version $version_length`\033[0m"
  echo
else
  echo
  echo -e "\033[1;33mDownloading new version: $current_boxcryptor\033[0m"
  echo
  curl -sL https://ptc.secomba.com/api/boxcryptor/linuxPortable/latest -o $current_boxcryptor

  temp=temp
  mkdir $temp
  cp $current_boxcryptor $temp
  cd $temp
  tar -xf $current_boxcryptor
  cd ..
  
  # remove old files
  rm -rf Boxcryptor/runtime
  rm -rf Boxcryptor/exec
  rm Boxcryptor/app/*
  rm README.txt
  rm Boxcryptor_Portable.sh
  
  # delete oldest tar.gz version (3rd .tar.gz file is deleted - sorted by newest)
  rm $(find -printf "%TY-%Tm-%Td %TT %p\n" | sort -nr | grep tar.gz | sed -n 4p | cut -d '/' -f2) 

  mv $temp/README.txt .
  mv $temp/Boxcryptor_Portable.sh .

  mv $temp/Boxcryptor/app/* Boxcryptor/app/
  mv $temp/Boxcryptor/exec Boxcryptor
  mv $temp/Boxcryptor/runtime Boxcryptor

  rm -rf $temp
fi

