#!/bin/bash

SEP=$(printf "=================\n\n")

cd ~/Documents/scripts
echo get timetracking file
./work_timetracking.sh

echo
echo git pull scripts
echo
git pull
echo $SEP

echo git pull pythoncode
echo
cd ~/Documents/pythoncode; git pull
echo $SEP

echo git pull c
echo
cd ~/Documents/c/; git pull
echo $SEP

echo git pull cpp
echo
cd ~/Documents/cpp/; git pull

