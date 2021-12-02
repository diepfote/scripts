#!/usr/bin/env bash


if [ $# -lt 2 ]; then
  private='--private-window'
  TMP_FILE="$1"
else
  TMP_FILE="$2"
fi

#brave=$2

#if [ -z $brave ]; then
  ## call chrome
  #vivaldi-stable --incognito $TMP_FILE 2>/dev/null 1>/dev/null &
#else
  #brave $TMP_FILE 2>/dev/null 1>/dev/null &
#fi

#if [ "$?" -eq 127 ] || [ "$(which vivaldi-stable)" == "" ] ; then # google-chrome-stable not found
  #firefox --private-window $TMP_FILE 2>/dev/null 1>/dev/null &
#fi


if [ "$(uname)" = Darwin ]; then
  source ~/.sh_functions
set -x
  open_mac-os_app Firefox.app "$private" "$TMP_FILE"
set +x
else
set -x
  firefox "$private" "$TMP_FILE" 2>/dev/null 1>/dev/null &
set +x
fi

sleep 2

