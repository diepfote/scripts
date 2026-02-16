#!/usr/bin/env bash

set -o pipefail  # propagate errors
set -u  # exit on undefined
set -e  # exit on non-zero return value
#set -f  # disable globbing/filename expansion
shopt -s failglob  # error on unexpaned globs


trap cleanup EXIT
cleanup () { kill "$hashcards_pid"; }

~/.bin/hashcards drill --open-browser false ~/flashcards &
hashcards_pid=$!


dns_server="$(~/.bin/read-ini-setting ~/.config/personal/services.conf tailscale_dns)"
ts_hostname="$(~/.bin/read-ini-setting ~/.config/personal/services.conf hostname)"
ts_ip="$(drill -Q @"$dns_server" "$ts_hostname")"

local_ssh_key="$(~/.bin/read-ini-setting ~/.config/personal/ssh.conf ssh_key local)"
local_ssh_port="$(~/.bin/read-ini-setting ~/.config/personal/ssh.conf ssh_port local)"
ssh -i "$local_ssh_key" -p "$local_ssh_port" -NT -L "$ts_ip":8000:localhost:8000 "$USER"@localhost 


