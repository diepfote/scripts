#!/usr/bin/env bash

user=`cut -d : -f 1 /etc/passwd | grep flo | head -n 1`
user_dir=/home/$user

cd $user_dir/Documents/pentesting_pkgs/noisy

python noisy.py --config config.json

