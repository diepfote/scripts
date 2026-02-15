#!/usr/bin/env bash

interface_name=eth0
if ! ip addr | grep -F "${interface_name}:" >/dev/null 2>&1; then ~/.bin/ntf send -t "$(hostname)" "network card name change: $(ip addr | grep -vE '^ ')"; fi

