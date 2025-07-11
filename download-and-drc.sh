#!/usr/bin/env bash


set -o pipefail  # propagate errors
set -u  # exit on undefined
set -e  # exit on non-zero return value
#set -f  # disable globbing/filename expansion
shopt -s failglob  # error on unexpaned globs

source ~/Repos/scripts/source-me/posix-compliant-shells.sh

temp_dir="$(mktemp -d)"

# Parse arguments
LINK=''
BATCH_FILE=''
FOLDER_NAME=''
DATE_STAMP=''
while [ $# -gt 0 ]; do
key="$1"
  case "$key" in
    --link)
    LINK="$2"
    shift 2
    ;;

    --batch-file)
    BATCH_FILE="$2"
    shift 2
    ;;

    --folder-name)
    FOLDER_NAME="$2"
    shift 2
    ;;

    --date-stamp)
    DATE_STAMP="$2"
    shift 2
    ;;

    -h|--help)
    _help
    exit 0
    ;;

    --)
    shift
    break
    ;;

    *)
    break
    ;;

  esac
done

cleanup () {
  set +x
  popd
  rm -r "$temp_dir"
}
trap cleanup EXIT

system="$(uname)"
if [ "$system" = Linux ]; then
  set -x
  dir=~/Videos/audio-only/"$FOLDER_NAME"
  set +x
elif [ "$system" = Darwin ]; then
  set -x
  dir=~/Movies/audio-only/"$FOLDER_NAME"
  set +x
fi

set -x
pushd "$temp_dir"
set +x

if [ -z "$FOLDER_NAME" ]; then
  echo 'No FOLDER_NAME'
  exit 1
fi

if [ -n "$BATCH_FILE" ]; then
  set -x
  dl-youtube 251-drc -a "$BATCH_FILE"
  set +x
elif [ -n "$LINK" ] && [ -n "$DATE_STAMP" ]; then
  set -x
  upload_filter="upload_date>=$(date '+%Y%m%d' --date="$DATE_STAMP")"
  dl-youtube 251-drc "$LINK"  -i --match-filter "$upload_filter"
  set +x
else
  echo 'No BATCH_FILE or DATE_STAMP + LINK'
  exit 1
fi

# since we no longer are able to use format=140 we are provided with .webm files
for f in "$temp_dir"/*.webm; do
  replaced_ext="$(echo "$f" | sed -r 's#(.*).webm$#\1.m4a#')"
  mv "$f" "$replaced_ext"
done

# we use a drc'ed format
set -x
ffmpeg-dynamic-range-compress-dir "$temp_dir"
set +x

set -x
mv "$temp_dir"/* "$dir"
set +x
