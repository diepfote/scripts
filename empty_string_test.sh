#!/bin/sh
nulltest()
{
if [ ! ${#var} -eq 0 ]
then
  echo "NULL, empty string..."
else
  echo "Not an empty string..."
fi
}
var=""
nulltest
var=NULL
nulltest

