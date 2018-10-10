#!/usr/bin/env bash
TMP_FILE=$1
brave=$2

if [ -z $brave ]; then
  # call chrome
  vivaldi-stable $TMP_FILE 2> /dev/null 1> /dev/null &
else
  brave $TMP_FILE 2> /dev/null 1> /dev/null &
fi

if [ "$?" -eq 127 ]; then # google-chrome-stable not found
	chromium-browser $TMP_FILE 2> /dev/null 1> /dev/null
fi

sleep 2

