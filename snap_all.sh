#!/bin/sh

vol_group_mapper=/dev/mapper/VolGroup00
d=$(date '+%Y-%m-%d_%H-%M-%S')

dir=root
size='2.5GB'
sudo lvcreate -L $size -s -n s_$dir-$d $vol_group_mapper-$dir

dir=boot
size=156MB
sudo lvcreate -L $size -s -n s_$dir-$d $vol_group_mapper-$dir

dir=home
size='2.5GB'
sudo lvcreate -L $size -s -n s_$dir-$d $vol_group_mapper-$dir

dir=var
size='2.5GB'
sudo lvcreate -L $size -s -n s_$dir-$d $vol_group_mapper-$dir

dir=opt
size='2.5GB'
sudo lvcreate -L $size -s -n s_$dir-$d $vol_group_mapper-$dir

