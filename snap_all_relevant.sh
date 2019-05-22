#!/bin/sh

vol_group_mapper=/dev/mapper/VolGroup00
# create a local timestamp
d=$(date +%FT%T%Z | sed 's/:/--/g')
d="${d//:/-}"

is_private_laptop="$(hostname | grep arch-dev)"
# only on private laptop
if [ ! -z $is_private_laptop ]; then
  dir=boot
  size=356MB
  sudo lvcreate -L $size -s -n s_$dir-$d $vol_group_mapper-$dir
fi

dir=home
size='15GB'
sudo lvcreate -L $size -s -n s_$dir-$d $vol_group_mapper-$dir

dir=root
size='1.5GB'
sudo lvcreate -L $size -s -n s_$dir-$d $vol_group_mapper-$dir


#dir=var
#size='2GB'
#sudo lvcreate -L $size -s -n s_$dir-$d $vol_group_mapper-$dir

#dir=opt
#size='2.5GB'
#sudo lvcreate -L $size -s -n s_$dir-$d $vol_group_mapper-$dir

