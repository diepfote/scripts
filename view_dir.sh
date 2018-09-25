#!/bin/bash

DIR=~/Documents/$1

trap "sudo chown -R root:root $DIR" EXIT

sudo chown -R $USER:$USER $DIR
xdg-open $DIR &>/dev/null

sleep infinity

