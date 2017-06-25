#!/bin/bash

IP_DESKTOP=$(sudo nmap -sn -PU161 10.0.0.1/28 | grep Flo-Desktop | grep -Eo '\((.*?)\)' | cut -d '(' -f2 | cut -d ')' -f1)
echo IP is $IP_DESKTOP

if mount | grep Videos 1> /dev/null; then
	printf '\033[1;31mVideos and Music already mounted. Exiting...\033[0m\n' 1>&2
	exit

else
	echo Mount in progress
	sudo mount -t cifs -o username=user,password=user,uid=1000,gid=1000 //$IP_DESKTOP/Video-Files ~/Videos/
	sudo mount -t cifs -o username=user,password=user,uid=1000,gid=1000 //$IP_DESKTOP/Music ~/Music/
	sudo mount -t cifs -o username=user,password=user,uid=1000,gid=1000 //$IP_DESKTOP/Software ~/Software/

	echo
	df -h
fi

