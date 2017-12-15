#!/bin/bash

SEP=$(printf "=================\n\n")

sudo echo 1>/dev/null

echo git fish functions
echo
cd ~/.config/fish/functions/; git pull
echo $SEP

echo git pull scripts
echo
cd ~/Documents/scripts
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
echo $SEP

echo
echo get time-tracking file
~/Documents/scripts/work_time-tracking.sh

