#!/bin/bash

DIR=~/Documents/$1
no_xdg=$2

trap 'sudo chown -R root:root "$DIR"' EXIT

sudo chown -R $USER:$USER "$DIR"
if [ "$?" != "0" ]; then
  echo Insufficient permissions, exiting.
  exit
fi

if [ -z $no_xdg ]; then
  xdg-open $DIR &>/dev/null
fi

sleep infinity

