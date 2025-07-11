#!/usr/bin/env bash


source ~/Repos/scripts/source-me/spinner.sh


spinner "$1"
read  # run spinner until <Enter> is pressed

kill %%  2>/dev/null  # kill last job; and do not emit an error message if the job is not found

