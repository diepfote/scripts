#!/bin/sh

# usage:
# ./measure_time.sh command

START=$(date +%s%N)

# run passed in command
$1 1>/dev/null 2>/dev/null

# your logic ends here
END=$(date +%s%N)
DIFF=$(( $END - $START ))

echo millisec $(($DIFF/1000000))

