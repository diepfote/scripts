#!/usr/bin/env bash


source source-me_progressbar.sh


progressbar "emit some $PURPLE text$NC" &
read  # run progressbar until <Enter> is pressed

kill %%  # kill last job

