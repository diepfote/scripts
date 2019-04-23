#!/usr/bin/env bash

rm -f /usr/share/applications/signal-desktop-tray.desktop
sed -i 's#/opt/Signal/signal-desktop#/usr/local/bin/signal-desktop#g' /usr/share/applications/signal-desktop.desktop

