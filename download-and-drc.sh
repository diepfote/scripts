#!/usr/bin/env bash


set -o pipefail  # propagate errors
set -u  # exit on undefined
set -e  # exit on non-zero return value
#set -f  # disable globbing/filename expansion
# shopt -s failglob  # error on unexpaned globs

source ~/Repos/scripts/source-me/posix-compliant-shells.sh

temp_dir="$(mktemp -d)"

# Parse arguments
FORMAT=0
BATCH_FILE=''
FOLDER_NAME=''
while [ $# -gt 0 ]; do
key="$1"
  case "$key" in
  --format)
    FORMAT="$2"
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
  # echo "[!] not deleting $temp_dir" >&2
  rm -r "$temp_dir"
}
trap cleanup EXIT


dir="$(read-ini-setting ~/.config/personal/podcast-download.conf download-dir || echo -n)"
if [ -z "$dir" ]; then
  system="$(uname)"
  if [ "$system" = Linux ]; then
    dir=~/Videos/audio-only
  elif [ "$system" = Darwin ]; then
    dir=~/Movies/audio-only
  fi
fi
dir="$dir/$FOLDER_NAME"
echo "[.] Files will be moved '$dir' if everything runs smoothly." >&2


pushd "$temp_dir"

if [ -z "$FOLDER_NAME" ]; then
  echo 'No FOLDER_NAME' >&2
  exit 1
fi

if [ -z "$BATCH_FILE" ]; then
  echo 'No BATCH_FILE' >&2
  exit 1
fi


_add_metadata() {
  set +x

  mkdir -p finished
  curl -L -s -o current.html "$line"

  pub_date="$(htmlq --text '#scrollable-page > main > div > div > div.section.section--information.svelte-1cj8vg9 > div.shelf-content > ul > li:nth-child(3) > div.content.svelte-sy8mrl' < current.html | ~/Repos/python/tools/date-rewrite-for-exiftool.py)"

  show_notes="$(htmlq '#scrollable-page > main > div > div > div.section.section--paragraph.svelte-1cj8vg9.section--display-separator > div > div' < current.html)"

  title="$(htmlq --text '#scrollable-page > main > div > div > div.section.section--episodeHeaderRegular.svelte-1cj8vg9.without-bottom-spacing > div > div > div.headings.svelte-1uuona0 > h1 > span' < current.html)"

  set -x
  exiftool -overwrite_original_in_place -'ContentCreateDate'="$pub_date" "$replaced_ext"

  exiftool -overwrite_original_in_place -'Description'="$show_notes" "$replaced_ext"

  exiftool -overwrite_original_in_place -'Title'="$title" "$replaced_ext"
  set +x


  sanitized_date="$( echo -n "$pub_date" | sed -r 's#^([0-9]+):([0-9]+):([0-9]+) ([0-9]+):([0-9]+):([0-9]+)#\1-\2-\3 \4.\5.\6#' )"
  final_fname="$title-$sanitized_date.m4a"
  set -x
  mv "$replaced_ext" finished/"$final_fname"
  set +x

  rm current.html
}

count=0
while read -u 9 -r line; do
  count=$((count+1))
  echo "[.] working on: $count: $line" >&2

  dl-youtube "$FORMAT" "$line"

  if [ "$(find *.mp3 | wc -l)" -gt 1 ]; then
    echo "Too many mp3 files (only one expected)." >&2
    exit 10
  fi
  file="$(find *.mp3)"
  replaced_ext="$(echo -n "$file" | sed -r 's#(.*).mp3$#\1.m4a#' )"
  set -x
  mv "$file" "$replaced_ext"
  set +x

  set -x
  ffmpeg-dynamic-range-compress-file --vbr 1 "$replaced_ext"
  set +x

  set -x
  _add_metadata
  set +x

done 9< "$BATCH_FILE"

set -x
mv "$temp_dir"/finished/* "$dir"
set +x

