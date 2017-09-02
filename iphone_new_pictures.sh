#!/bin/bash

trap "fusermount -u ~/iPhone/" EXIT
ifuse ~/iPhone/

sleep 1

cd ~/Documents/iphone_pictures

is_newer_available=false
latest_backup=$(ls -t | head -1)
latest_file=$(ls -t $latest_backup | head -1)

f_date=$(date '+%m-%d-%Y_%H-%M-%S')
mkdir $f_date

for f in $(find ~/iPhone/DCIM -name *.JPG); do
  cp -p $(find $f -newer "/home/flo/Documents/iphone_pictures/$latest_backup/$latest_file") $f_date 2>/dev/null
#  if find $f -newer "/home/flo/Documents/iphone_pictures/$latest_backup/$latest_file"; then
 #   cp $f $f_date
#    is_newer_available=true
#    echo New file: $f
#  fi
done

is_new_files=$(ls $f_date)

if $is_new_files; then
  rm -rf $f_date
  echo No new files found.
  echo
fi

sleep 1

