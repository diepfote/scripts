#!/bin/bash
START=$(date +%s%N)
# do something
# start your script work here

# run passed in command
$1 1>/dev/null 2>/dev/null

# your logic ends here
END=$(date +%s%N)
DIFF=$(( $END - $START ))

echo millisec $(($DIFF/1000000))
