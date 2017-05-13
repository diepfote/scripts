#!/bin/bash

FILE='/tmp/rk_.html'
# function cleanup {
# 	sudo rm -f $FILE
# }
# trap cleanup EXIT
trap "sudo rm -f $FILE" EXIT

DAY="tuesday"
NUM_WEEKS=0

# Weeks to go forward
# Is the first parameter a valid int.
if [[ "$1" =~ ^-?[0-9]+$ ]]; then
	NUM_WEEKS=$1
fi


# Day to display in first parameter
if [ "$1" == "sun" ]; then
	DAY="sunday"
fi

# Day to display in second parameter
if [ "$2" == "sun" ]; then
	DAY="sunday"
fi


DATE=$(date -d"$DAY+$NUM_WEEKS weeks" +%Y-%m-%d)
PASS=$(sudo find ~ -name 'rk.txt')
PY_F=$(find ~ -name 'rk_.py' 2> /dev/null) # Pipe error messages to stderror to null

sudo python $PY_F $DATE $FILE $PASS

if [ -f $FILE ]; then
	google-chrome-stable $FILE 2> /dev/null

	if [ "$?" -eq 127 ]; then # google-chrome-stable not found
		chromium-browser $FILE
	fi
fi
