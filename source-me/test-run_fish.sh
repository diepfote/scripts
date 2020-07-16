#!/usr/bin/env bash


run_fish ()
{
  ~/Documents/python/run_fish.py $@
  sleep 1
  set -x
  ls -alh /tmp/tmpout
  bat /tmp/tmpout
  set +x
}

