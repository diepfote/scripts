#!/bin/bash

upper_dir="/home/flo"
trap "fusermount -u $upper_dir/iPhone/" EXIT
ifuse $upper_dir/iPhone/

sleep 1

LOCAL_PICTURES_DIR=$upper_dir/Documents/iphone_pictures
IPHONE_DCIM_DIR=$upper_dir/iPhone/DCIM
cd $LOCAL_PICTURES_DIR

is_newer_available=false
latest_backup_dir=$(ls -t | head -1)
latest_file=$(ls -t $latest_backup_dir/ | head -1)

f_date=$(date '+%m-%d-%Y_%H-%M-%S')
mkdir $f_date

for f in $(find $IPHONE_DCIM_DIR -name "*IMG*"); do
  # FAILS HERE    
  cp -p $(find $f -newer "$LOCAL_PICTURES_DIR/$latest_backup_dir/$latest_file") "$LOCAL_PICTURES_DIR/$f_date" 2>/dev/null
done

cd "$LOCAL_PICTURES_DIR/$f_date"
is_new_files=$(ls)

if $is_new_files; then
  cd ..
  rm -rf $f_date
  echo No new files found.
  echo
fi

sleep 1

