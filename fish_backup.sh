#!/bin/bash

fish_dir=/home/flo/.local/share/fish
fish_back_dir=$fish_dir/back
f_date=$(date '+%m-%d-%Y_%H-%M-%S')

cp $fish_dir/fish_history $fish_back_dir/fish_history$f_date

# Remove 10th file
rm -f $fish_back_dir/`ls -t $fish_back_dir | sed -n 10p` 2>/dev/null

