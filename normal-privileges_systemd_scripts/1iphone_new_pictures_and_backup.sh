#!/usr/bin/env bash

# shellcheck disable=SC1090


source ~/Documents/scripts/source-me/common-functions.sh
export user_dir="$HOME"
source /etc/systemd/system/scripts/source-me/common-functions.sh

set -o pipefail  # propagate errors
set -u  # exit on undefined
set -e  # exit on non-zero return value
#set -f  # disable globbing/filename expansion
shopt -s failglob  # error on unexpaned globs

exit_handler () {
  fusermount -u "$IFUSE_MOUNTPOINT"
}
trap exit_handler EXIT


tar_gzip_backup () {
  local date_for_file dir_to_compress full_path_to_dir_to_compress
  date_for_file="$(date +%FT%T%z | sed 's/:/_/g')"
  full_path_to_dir_to_compress="$1"
  dir_to_compress="$(basename "$full_path_to_dir_to_compress")"

  # cd dir above UUID dir
  pushd "$(dirname "$full_path_to_dir_to_compress")" || exit 1

  number_of_cores="$(nproc)"
  number_of_cores_to_use=$((number_of_cores - 4))

  set -x
  tar cf - "$dir_to_compress" |\
    pigz -p "$number_of_cores_to_use" -c > "$dir_to_compress-$date_for_file.tgz"
  set +x

  popd || exit 1
}

rm_old_tar_gzip_backup () {
  local dirs
  dirs=()

  while IFS='' read -r line; do
    dirs+=( "$line" )
  done < <(find-sorted "$1" -name '*.tgz' | tail -n +7)  # leave 6 backups in place

  for dir in "${dirs[@]}"; do
    set -x
    rm "$dir"
    set +x
  done
}

do_image_copy () {
  echo 'Start iPhone image copy and backup'

  ifuse "$IFUSE_MOUNTPOINT"

  sleep 1
  if ! pushd "$LOCAL_PICTURES_DIR"; then
    echo '[.] Failed to cp images -> we failed to cd into '"$LOCAL_PICTURES_DIR"'.' >&2
    return
  fi

  local backup_dirs files_on_laptop

  # all timestamped folders that contain image backups
  backup_dirs=()
  while IFS='' read -r line; do
    backup_dirs+=( "$line" )
  done < <(find-sorted . -type d)
  # echo DEBUG "${backup_dirs[0]}"
  # exit

  # files in newest backup dir
  files_on_laptop=()
  while IFS='' read -r line; do
    files_on_laptop+=( "$line" )
  done < <(find-sorted "${backup_dirs[0]}")

  local f_date
  f_date="$(date '+%FT%T%z' | sed 's/:/_/g')"
  mkdir "$f_date"  # new backup folder

  local files_on_phone
  files_on_phone=()
  while IFS='' read -r line; do
    files_on_phone+=( "$line" )
  done < <(find "$IPHONE_DCIM_DIR" -name "*IMG*")

  for f in "${files_on_phone[@]}"; do

    local newer_file
    newer_file="$(find "$f" -newer "$LOCAL_PICTURES_DIR/${files_on_laptop[0]}")"

    # check file on phone newer than newest file in backups
    if [ -n "$newer_file" ]; then
      set -x
      cp "$newer_file" "$LOCAL_PICTURES_DIR/$f_date"
      set +x
    fi
    unset newer_file
  done

  local new_files num_new_files

  # way too complicated check to see whether new files
  # have been copied
  new_files=()
  while IFS='' read -r line; do
    new_files+=( "$line" )
  done < <(find "$LOCAL_PICTURES_DIR/$f_date" -mindepth 1)
  num_new_files=${#new_files[@]}

  if [ "$num_new_files" -ne 0 ]; then
    echo 'Copied new files from device.'
  else
    rm -rf "${LOCAL_PICTURES_DIR:?}"/"${f_date:?}"
    echo 'No new files found.'
  fi
  echo 'iPhone image copy and backup end'

  popd || exit 1
  sleep 1
}

# only run on my private laptop
is_private_laptop="$(hostname | grep arch-dev)"
if [ -z "$is_private_laptop" ]; then
  echo "Wrong laptop, exiting without error."
  exit
fi


IFUSE_MOUNTPOINT="$(mktemp -d)"
IPHONE_DCIM_DIR="$IFUSE_MOUNTPOINT"/DCIM


set_backup_drive backup_drive
# shellcheck disable=SC2154
iphone_backup_loc="$backup_drive"/iPhone
set_backup_drive big_drive
LOCAL_PICTURES_DIR="$backup_drive"/#Photos


do_image_copy
set -x
idevicebackup2 -u "$(idevice_id -l | head -n1)" backup  "$iphone_backup_loc"
set +x

iphone_backup_loc_UUID_dir="$(find "$iphone_backup_loc" -maxdepth 1 -type d | tail -n 1)"
tar_gzip_backup "$iphone_backup_loc_UUID_dir"

rm_old_tar_gzip_backup "$iphone_backup_loc"

echo 'END iPhone image copy and backup'

