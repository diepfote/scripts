#!/bin/bash

SEP=$(printf "=================\n\n")

cd ~/Documents/scripts
echo get time-tracking file
./work_time-tracking.sh

echo
echo git pull scripts
echo
git pull
echo $SEP

echo git pull python
echo
cd ~/Documents/python; git pull
echo $SEP

echo git pull c
echo
cd ~/Documents/c/; git pull
echo $SEP

echo git pull cpp
echo
cd ~/Documents/cpp/; git pull

echo git fish functions
echo
cd ~/.config/fish/functions/; git pull

