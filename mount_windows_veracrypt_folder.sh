#!/usr/bin/env bash

user=$(cut -d : -f 1 /etc/passwd | grep flo | head -n 1)
veracrypt_file=/home/"$user"/Win_Part/Users/Dev/Desktop/veracrypt_folder.hc
mount_point=windows_veracrypt_folder
temp=$(mktemp -d)

trap "sudo umount $temp; sudo cryptsetup close $mount_point; rm -rf $temp" EXIT

sudo cryptsetup --type tcrypt --veracrypt open "$veracrypt_file" "$mount_point"
sudo mount /dev/mapper/"$mount_point" "$temp"
if [ "$?" == "0" ]; then
  echo "Success, view under $temp."
  xdg-open "$temp" 1>/dev/null 2>/dev/null
fi
sleep infinity

