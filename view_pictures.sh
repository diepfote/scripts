#!/bin/bash

PICT_DIR=~/Documents/iphone_pictures/

trap "sudo chown -R root:root $PICT_DIR" EXIT

sudo chown -R $USER:$USER $PICT_DIR
xdg-open $PICT_DIR &>/dev/null

sleep infinity

