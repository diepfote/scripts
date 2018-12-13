#!/usr/bin/env bash

# This script either takes a path to a folder containing PDF files or
# assumes the current directory is where relevant PDF files reside
#
directory=$1
if [ -z $directory ]; then
  directory=$(pwd)
fi

END=$(ls $directory | wc -l)

for i in $(seq 1 $END); do
  filename=$(ls $directory | head -n $i | tail -n 1)
  if [ "${filename##*.}" == "pdf" ]; then
    NUM_PAGES_ARRAY[$i]=$(pdfinfo $directory/"$filename" 2>/dev/null | grep 'Pages: ' | cut -d ':' -f2)
    
    echo $filename
    echo ${NUM_PAGES_ARRAY[$i]}
    echo ---------
  fi
done

string=$(echo ${NUM_PAGES_ARRAY[*]})
to_calc=$(echo ${string// /'+'})

echo
echo SUM
echo $to_calc | bc

