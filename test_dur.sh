#!/bin/bash
START=$(date +%s%N)
# do something
# start your script work here

~/Documents/scripts/rk_.sh

# your logic ends here
END=$(date +%s%N)
DIFF=$(( $END - $START ))

echo millisec $(($DIFF/1000000))
