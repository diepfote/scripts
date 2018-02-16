#!/bin/sh

# usage:
# ./time-it.sh command arg1 arg2 arg3 ...

START=$(date +%s%N)

# run passed in command
"$@"

# your logic ends here
END=$(date +%s%N)
DIFF=$(( $END - $START ))

echo millisec $(($DIFF/1000000))

