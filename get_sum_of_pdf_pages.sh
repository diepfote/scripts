#!/usr/bin/env bash

# TODO should not run find twice
result_for_each="$(find "$@" -type f -iname '*.pdf' -exec bash -c 'echo -n "{}"; pdfinfo "{}"  2>/dev/null | grep "Pages:" | sed "s#Pages:##g"' \;)"
calc_command="$(find "$@" -type f -iname '*.pdf' -exec bash -c 'pdfinfo "{}"  2>/dev/null | grep 'Pages: ' | cut -d ':' -f2' \; | sed 's#Pages: ##g' | tr '\n' '+') 0"

echo -e "$result_for_each" | sort

echo; echo -n "SUM: "; echo "$calc_command" | bc

