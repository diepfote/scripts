#!/usr/bin/env bash
echo $(cat $1 | grep $2 | sed 's#[A-Za-z0-9_-]*=##' | head -n 1)

