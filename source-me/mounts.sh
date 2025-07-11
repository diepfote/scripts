#!/usr/bin/env bash

temp_mount=/temp-mount/
file=Repos/scripts/source-me/common-functions.sh
source ~/"$file" || source "$temp_mount$file"
file=Repos/scripts/source-me/spinner.sh
source ~/"$file" || source "$temp_mount$file"

