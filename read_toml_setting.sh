#!/usr/bin/env bash
echo $(cat $1 | grep $2 | cut -d '=' -f2 | head -n 1)

