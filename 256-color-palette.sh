#!/usr/bin/env bash
for i in {0..255} ; do
  rem="$(echo "$i % 9" | bc)"
  if [ "$rem" -eq 0 ]; then
    echo
  fi

  echo -n -e "\x1b[38;5;${i}mcolour${i} "
done
echo
