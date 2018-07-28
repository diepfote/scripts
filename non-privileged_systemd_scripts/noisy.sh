#!/usr/bin/env bash

user=`cut -d : -f 1 /etc/passwd | grep flo`
user_dir=/home/$user

cd $user_dir/Documents/pentesting_pkgs/noisy

python noisy.py --config config.json

