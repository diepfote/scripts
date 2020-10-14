#!/usr/bin/env bash


source ~/Documents/scripts/source-me/progressbar.sh


progressbar "$1"
read  # run progressbar until <Enter> is pressed

kill %%  2>/dev/null  # kill last job; and do not emit an error message if the job is not found

