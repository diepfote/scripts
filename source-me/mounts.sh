#!/usr/bin/env bash

temp_mount=/temp-mount/
file=Documents/scripts/source-me/common-functions.sh
source ~/"$file" || source "$temp_mount$file"
file=Documents/scripts/source-me/spinner.sh
source ~/"$file" || source "$temp_mount$file"

