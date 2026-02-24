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


dir="$(read-ini-setting ~/.config/personal/podcast-download.conf download_dir || echo -n)"
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
  local try_count pubdate md_filename_pubdate sanitized_date final_fname prefix show_notes title

  mkdir -p finished
  curl -L -s -o current.html "$line"

  pubdate="$(htmlq --text '.information > li:nth-child(3) > div:nth-child(2)' < current.html | date-rewrite)"

  try_count=0
  md_filename_pubdate="$(echo -n "$pubdate" | date-rewrite "$(read-ini-setting ~/.config/personal/podcast-download.conf date_format)")"
  prefix="$(read-ini-setting ~/.config/personal/podcast-download.conf prefix)"
  while true; do
    if [ "$try_count" -gt 10 ]; then
      exit 100
    fi
    (( try_count = try_count + 1 ))
    rc="$(curl -s -o /dev/null -w "%{http_code}\n" "$prefix/$md_filename_pubdate".md)"
    if [ "$rc" -eq 200 ]; then
      break
    fi

    # decrement date by 1 dy
    # snatched from https://www.perplexity.ai/search/use-a-date-like-2025-12-15-in-OKGasZyPRi2n1EAgbkHrMQ
    md_filename_pubdate="$(date -d "${md_filename_pubdate//_/\/} - 1 day" +%Y_%m_%d)"
  done
  show_notes="$(curl -s "$prefix/$md_filename_pubdate".md)"

  title="$(htmlq --text '.headings__title > span:nth-child(1)' < current.html)"

  set -x
  exiftool -overwrite_original_in_place -'ContentCreateDate'="$pubdate" "$replaced_ext"

  exiftool -overwrite_original_in_place -'Description'="$show_notes" "$replaced_ext"

  exiftool -overwrite_original_in_place -'Title'="$title" "$replaced_ext"
  set +x


  sanitized_date="$( echo -n "$pubdate" | sed -r 's#^([0-9]+):([0-9]+):([0-9]+) ([0-9]+):([0-9]+):([0-9]+)#\1-\2-\3 \4.\5.\6#' )"
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
  fdkaac-dynamic-range-compress-file -m 2 "$replaced_ext"
  set +x

  set -x
  _add_metadata
  set +x

done 9< "$BATCH_FILE"

set -x
mv "$temp_dir"/finished/* "$dir"
set +x

