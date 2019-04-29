#!/usr/bin/env bash

cd ~/Downloads
file=$(ls -t | head -n 1)

cat $file

