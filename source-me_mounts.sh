#!/usr/bin/env bash

source ~/Documents/scripts/source-me_common-functions.sh
source ~/Documents/scripts/source-me_progressbar.sh

mount_luks_device ()
{
  local pass="$1"
  local device_partition="$2"
  local mount_point="$3"
  local mapper_name="$(get_random_alphanumeric 32)"

  trap "sudo umount "$mount_point"; sudo rm -r "$mount_point"; sudo cryptsetup close "$mapper_name"" EXIT

  echo "$pass" | sudo cryptsetup open "$device_partition" "$mapper_name"
  sudo mkdir "$mount_point" || true  # dir exists
  sudo mount /dev/mapper/"$mapper_name" "$mount_point"

  tmux split-window -d -v
  tmux send-keys -t .+ "n $mount_point" C-m

  progressbar 'waiting to close encrypted drive'

  while true; do
    sudo -v
    sleep 60
  done
}

