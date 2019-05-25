#!/usr/bin/env bash

git log --graph --pretty=format:'%C(bold cyan)%h%Creset%C(bold magenta)%d%Creset %C(bold green)<%cn>%Creset %C(bold red)(%ci)%Creset %s' "$@"

