#!/usr/bin/env bash

#set -x

# TODO should not run find twice
result_for_each="$(find "$@" -type f -exec bash -c 'x=$(pdfinfo "{}"  2>/dev/null | grep "Pages:" 2>/dev/null | sed "s#Pages:##g" | sed "s# ##g" 2>&1); echo -e  "{}\t\t\t$x" ' \;)"
calc_command="$(find "$@" -type f -exec bash -c 'pdfinfo "{}"  2>/dev/null | grep -I 'Pages: ' 2>/dev/null | cut -d ':' -f2' \; | sed 's#Pages: ##g' | tr '\n' '+') 0"

echo -e "$result_for_each"  | sed 's#^./##' |  sort -n

echo; echo -n "SUM: "; echo "$calc_command" | bc

