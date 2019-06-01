#!/usr/bin/env bash

# This script either takes a path to a folder containing PDF files or
# assumes the current directory is where relevant PDF files reside
#
directory="$@"
if [ -z "$directory" ]; then
  directory=.
fi

# TODO should not run find twice
find "$directory" -type f -iname '*.pdf' -exec bash -c 'echo "{}"; pdfinfo "{}"  2>/dev/null | grep 'Pages: '; echo' \;
calc_command="$(find "$directory" -type f -iname '*.pdf' -exec bash -c 'pdfinfo "{}"  2>/dev/null | grep 'Pages: ' | cut -d ':' -f2' \; | sed 's#Pages: ##g' | tr '\n' '+') 0"

echo
echo -n "SUM: " 
echo "$calc_command" | bc

