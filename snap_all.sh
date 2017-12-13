#!/bin/sh

vol_group_mapper=/dev/mapper/VolGroup00
d=$(date '+%m-%d-%Y_%H-%M-%S')

dir=root
size=1GB
sudo lvcreate -L $size -s -n s_$dir-$d $vol_group_mapper-$dir

dir=boot
size=152MB
sudo lvcreate -L $size -s -n s_$dir-$d $vol_group_mapper-$dir

dir=home
size=1GB
sudo lvcreate -L $size -s -n s_$dir-$d $vol_group_mapper-$dir

dir=var
size=1GB
sudo lvcreate -L $size -s -n s_$dir-$d $vol_group_mapper-$dir

dir=opt
size=1GB
sudo lvcreate -L $size -s -n s_$dir-$d $vol_group_mapper-$dir

