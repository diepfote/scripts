#!/usr/bin/env bash

DIR=~/Documents/$1
no_xdg=$2

trap 'sudo chown -R root:root "$DIR"; sudo chmod -R 000 "$DIR"' EXIT

sudo chmod -R 700 "$DIR"
sudo chown -R $USER:$USER "$DIR"
if [ "$?" != "0" ]; then
  echo Insufficient permissions, exiting.
  exit
fi

if [ -z $no_xdg ]; then
  xdg-open $DIR &>/dev/null
fi

sleep infinity

