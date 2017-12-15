#!/bin/bash

echo
echo -e "\033[1;33mStart remove diagnostics\033[0m"
t=$(mktemp -d)

idevicecrashreport -e $t
rm -rf $t

echo -e "\033[1;33mEnd remove diagnostics\033[0m"

