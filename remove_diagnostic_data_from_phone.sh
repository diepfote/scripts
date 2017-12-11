#!/bin/bash
t=(mkdir -d)

idevicecrashreport -e $t
rm -rf $t

