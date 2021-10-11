#!/usr/bin/env bash

source ~/Documents/scripts/kubernetes/source-me/common-functions.sh

complete -o filenames -F _set-kubecontext_complete set-kubecontext

