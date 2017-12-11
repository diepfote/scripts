#!/bin/bash

if [ $SUDO_USER ]; then user=$SUDO_USER; else user=`whoami`; fi
user_dir=/home/$user

mv $user_dir/Pictures/Screenshot* $user_dir/Pictures/screenshots/

