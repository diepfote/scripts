#!/usr/bin/env bash

vdi_file="$1"
mount_partition="$2"
[[ -z "$mount_partition" ]] && mount_partition=2

temp=$(mktemp -d)

trap "sudo umount '$temp'; sudo qemu-nbd -d /dev/nbd0" EXIT

sudo modprobe -v nbd

set -x
# mount as disk
sudo qemu-nbd -c /dev/nbd0 "$vdi_file"

# mount partition
echo -en "$PURPLE"; echo -e "[?] attempting to mount partition 2 (might have to be changed).$NC"
sudo mount /dev/nbd0p"$mount_partition" "$temp"
set +x

xdg-open "$temp" 1>/dev/null 2>/dev/null


sleep infinity
