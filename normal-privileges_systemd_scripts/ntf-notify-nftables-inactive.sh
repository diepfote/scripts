#!/usr/bin/env bash

if ! sudo systemctl status nftables.service | grep -E 'Main PID.*SUCCESS'; then ~/.bin/ntf send -t "$(hostname)" "$(sudo systemctl status nftables.service)"; fi
