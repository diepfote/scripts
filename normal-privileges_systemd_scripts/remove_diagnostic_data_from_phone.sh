#!/bin/bash

echo
echo -e "\033[1;33mBegin remove diagnostics\033[0m"

t=$(mktemp -d)
trap "rm -rf $t" EXIT

idevicecrashreport -e $t

echo -e "\033[1;33mEnd remove diagnostics\033[0m"

