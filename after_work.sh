#!/bin/bash

SEP=$(printf "=================\n\n")

echo git pull scripts
echo
cd ~/Documents/scripts; git pull
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
