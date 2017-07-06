#!/bin/bash

find /var/cache/pacman/pkg -type d -exec paccache -v -r -k 2 -c {} \;
