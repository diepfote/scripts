#!/usr/bin/env bash
#
# shellcheck disable=SC1090

source ~/Documents/scripts/source-me/posix-compliant-shells.sh

IFUSE_MOUNTPOINT="$(mktemp -d)"
IPHONE_DCIM_DIR="$IFUSE_MOUNTPOINT"/DCIM

set -o pipefail  # propagate errors
set -u  # exit on undefined
set -e  # exit on non-zero return value
#set -f  # disable globbing/filename expansion
shopt -s failglob  # error on unexpaned globs

exit_handler () {
  # do not fail if device has been unplugged
  set -x
  fusermount -u "$IFUSE_MOUNTPOINT"  || true
  set +x
}
trap exit_handler EXIT


do_image_copy () {
  echo 'Start iPhone image copy and backup'

  set -x
  ifuse "$IFUSE_MOUNTPOINT"
  set +x

  sleep 1
  if ! pushd "$LOCAL_PICTURES_DIR"; then
    echo '[.] Failed to cp images -> we failed to cd into '"$LOCAL_PICTURES_DIR"'.' >&2
    return
  fi

  local backup_dirs files_on_laptop

  # last timestamp folder that contains image backups (based on last modified)
  backup_dirs=()
  while IFS='' read -r line; do
    backup_dirs+=( "$line" )
  done < <(find-sorted . -type d -maxdepth 1 | head -n1)
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
      if ! try_rsync; then
        sleep .5
        try_rsync
        if ! try_rsync; then
          sleep 1
          try_rsync
        fi
      fi
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

try_rsync () {
  rsync -av "$newer_file" "$LOCAL_PICTURES_DIR/$f_date/$(basename "$newer_file")"
}


# only run on my private laptop
is_private_laptop="$(hostname | grep frame.work)"
if [ -z "$is_private_laptop" ]; then
  echo "Wrong laptop, exiting without error."
  exit
fi


iphone_backup_loc="$(read_toml_setting ~/Documents/config/sync.conf iphone-backup)"
LOCAL_PICTURES_DIR="$(read_toml_setting ~/Documents/config/sync.conf photos)"

do_image_copy
set -x
idevicebackup2 -u "$(idevice_id -l | head -n1)" backup  "$iphone_backup_loc"
set +x

echo 'END iPhone image copy and backup'

