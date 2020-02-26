#!/usr/bin/env bash
TMP_FILE=$1
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
  open_mac-os_app Firefox.app --private-window "$TMP_FILE"
else
  firefox --private-window "$TMP_FILE" 2>/dev/null 1>/dev/null &
fi

sleep 2

