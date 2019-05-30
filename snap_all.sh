#!/usr/bin/env bash

vol_group_mapper=/dev/mapper/VolGroup00
# create a local timestamp
d=$(date +%FT%T%Z | sed 's/:/--/g')
d="${d//:/-}"

dir=home
size='4GB'
sudo lvcreate -L $size -s -n s_$dir-$d $vol_group_mapper-$dir

dir=root
size='6GB'
sudo lvcreate -L $size -s -n s_$dir-$d $vol_group_mapper-$dir

dir=boot
size=356MB
sudo lvcreate -L $size -s -n s_$dir-$d $vol_group_mapper-$dir

dir=var
size='4GB'
sudo lvcreate -L $size -s -n s_$dir-$d $vol_group_mapper-$dir

dir=opt
size='6GB'
sudo lvcreate -L $size -s -n s_$dir-$d $vol_group_mapper-$dir

