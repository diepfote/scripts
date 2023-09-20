#!/usr/bin/env bash

system="$(uname)"
if [ "$system" = Darwin ]; then
  launchctl start floriansorko.report-work-videos
elif [ "$system" = Linux ]; then
  systemctl start --user report-videos.service
fi

