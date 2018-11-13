#!/usr/bin/env bash
TMP_FILE=$1
#brave=$2

#if [ -z $brave ]; then
  ## call chrome
  #vivaldi-stable --incognito $TMP_FILE 2> /dev/null 1> /dev/null &
#else
  #brave $TMP_FILE 2> /dev/null 1> /dev/null &
#fi

#if [ "$?" -eq 127 ] || [ "$(which vivaldi-stable)" == "" ] ; then # google-chrome-stable not found
  #firefox --private-window $TMP_FILE 2> /dev/null 1> /dev/null
#fi

firefox --private-window $TMP_FILE 2> /dev/null 1> /dev/null

sleep 2

