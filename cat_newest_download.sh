#!/usr/bin/env bash

cd ~/Downloads
file=$(ls -t | head -n 1)

echo "[>] filename: $file"
cat $file

