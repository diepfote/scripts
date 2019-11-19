#!/usr/bin/env bash


source source-me_progressbar.sh


progressbar "emit some $PURPLE text$NC" &
read  # run progressbar until <Enter> is pressed

kill %%  2>/dev/null  # kill last job; and do not emit an error message if the job is not found

