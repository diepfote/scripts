#!/usr/bin/env bash

vdi_file=$1
temp=$(mktemp -d)

trap "sudo umount $temp; sudo qemu-nbd -d /dev/nbd0" EXIT

sudo modprobe -v nbd

# mount as disk
sudo qemu-nbd -c /dev/nbd0 $vdi_file

# mount partition
sudo mount /dev/nbd0p2 $temp

xdg-open $temp 1>/dev/null 2>/dev/null


sleep infinity
