#!/usr/bin/env bash

user=$(cut -d : -f 1 /etc/passwd | grep flo)
veracrypt_file=/home/"$user"/Win_Part/Users/Dev/Desktop/veracrypt_folder.hc
mount_point=windows_veracrypt_folder
temp=$(mktemp -d)

trap "sudo umount $temp; sudo cryptsetup close $mount_point; rm -rf $temp" EXIT

sudo cryptsetup --type tcrypt --veracrypt open "$veracrypt_file" "$mount_point"
sudo mount /dev/mapper/"$mount_point" "$temp"
if [ "$?" == "0" ]; then
  echo "Success, view under $temp."
fi
sleep infinity

