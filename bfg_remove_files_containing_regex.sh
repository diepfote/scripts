#!/usr/bin/env bash

for i in $(git grep -i "$1" $(git rev-list --all) | cut -d ':' -f2 | sort | uniq); do
  bfg -D "$i"
  #echo "$i"
done

