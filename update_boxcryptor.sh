#!/bin/bash

cd ~/Desktop/boxcr/

current_boxcryptor=$(curl -sI https://ptc.secomba.com/api/boxcryptor/linuxPortable/latest | grep Location | cut -d ':' -f3 | cut -d '/' -f7 | sed "s/\r//")

last_in_filesystem=$(find -printf "%TY-%Tm-%Td %TT %p\n" | sort -n | grep tar.gz | head -1 | cut -d ' ' -f3 | cut -d '/' -f2)

if echo $last_in_filesystem | grep $current_boxcryptor 1>/dev/null; then
  echo No new boxcryptor version.
else
  curl -sL https://ptc.secomba.com/api/boxcryptor/linuxPortable/latest -o $current_boxcryptor

  temp=temp
  mkdir $temp
  mv $current_boxcryptor $temp
  cd $temp
  tar -xf $current_boxcryptor
  cd ..
  
  # remove old files
  rm -rf Boxcryptor/runtime
  rm -rf Boxcryptor/exec
  rm Boxcryptor/app/*
  rm README.txt
  rm Boxcryptor_Portable.sh
  
  # delete oldest tar.gz version
  rm $(find -printf "%TY-%Tm-%Td %TT %p\n" | sort -n | grep tar.gz | head -1 | cut -d '/' -f2)


  mv $temp/README.txt .
  mv $temp/Boxcryptor_Portable.sh .

  mv $temp/Boxcryptor/app/* Boxcryptor/app/
  mv $temp/Boxcryptor/exec Boxcryptor
  mv $temp/Boxcryptor/runtime Boxcryptor

  rm -rf $temp
fi

