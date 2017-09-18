#!/bin/bash

current_boxcryptor=$(curl -sI https://ptc.secomba.com/api/boxcryptor/linuxPortable/latest | grep Location | cut -d ':' -f3 | cut -d '/' -f7 | sed "s/\r//")

#curl -sL https://ptc.secomba.com/api/boxcryptor/linuxPortable/latest -o $current_boxcryptor

last_in_filesystem=$(find -printf "%TY-%Tm-%Td %TT %p\n" | sort -n | grep tar.gz | head -1 | cut -d ' ' -f3 | cut -d '/' -f2)

if echo $last_in_filesystem | grep $current_boxcryptor 1>/dev/null; then
  echo No new boxcryptor version.
else
  # delete oldest version
  echo $(find -printf "%TY-%Tm-%Td %TT %p\n" | sort -n | grep tar.gz | head -1 | cut -d '/' -f2)

fi

