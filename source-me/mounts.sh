#!/usr/bin/env bash

temp_mount=/temp-mount/
file=Documents/scripts/source-me/common-functions.sh
source ~/"$file" || source "$temp_mount$file"
file=Documents/scripts/source-me/spinner.sh
source ~/"$file" || source "$temp_mount$file"

source ~/.sh_functions || /home/builder/.sh_functions


mount_luks_device ()
{
  local pass="$1"
  local device_partition="$2"
  local mount_point="$3"
  local mapper_name="$(get_random_alphanumeric 32)"

  trap "sudo umount "$mount_point"; sudo rm -r "$mount_point"; sudo cryptsetup close "$mapper_name"" EXIT

  sudo -v
  echo "$pass" | sudo cryptsetup open "$device_partition" "$mapper_name"
  sudo mkdir "$mount_point" || true  # dir exists
  sudo mount /dev/mapper/"$mapper_name" "$mount_point"

  n-for-dir-in-tmux-pane-below "$mount_point"
  spinner 'waiting to close encrypted drive'

  while true; do
    sudo -v
    sleep 60
  done
}

mount_vdi ()
{
  local vdi_file="$1"
  local mount_partition="$2"
  [[ -z "$mount_partition" ]] && local mount_partition=2

  local temp="$(mktemp -d)"

  trap "sudo umount '$temp'; rm -rf '$temp'; sudo qemu-nbd -d /dev/nbd0" EXIT

  sudo modprobe -v nbd

  set -x
  # mount as disk
  sudo qemu-nbd -c /dev/nbd0 "$vdi_file"

  # mount partition
  echo -en "$PURPLE"; echo -e "[?] attempting to mount partition 2 (might have to be changed).$NC"
  sudo mount /dev/nbd0p"$mount_partition" "$temp"
  set +x

  n-for-dir-in-tmux-pane-below "$temp"
  spinner 'waiting to close vdi file'

  while true; do
    sudo -v
    sleep 60
  done
}

mount_iso ()
{
  local file="$1"
  local temp="$(mktemp -d)"

  sudo mount -o loop  "$file" "$temp"
  trap "sudo umount "$temp"; rm -r "$temp"" EXIT

  n-for-dir-in-tmux-pane-below "$temp"
  spinner 'waiting to close iso file'

  while true; do
    sudo -v
    sleep 60
  done
}
