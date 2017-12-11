#!/bin/bash
t=(mktemp -d)

idevicecrashreport -e $t
rm -rf $t

