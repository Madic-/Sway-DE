#!/usr/bin/env bash

## Start program. Otherwise kill it

APP="$1"
if [ -n "$APP" ]; then APP_PID=$(pgrep -u $USER "$APP"); fi

if [ "$APP" == "remontoire" ] && [ -z "$APP_PID" ]; then
  /usr/bin/remontoire -c ~/.config/sway/sway.d/07_hotkeys.conf &
elif [ "$APP" == "wshowkeys" ] && [ -z "$APP_PID" ]; then
  /usr/bin/wshowkeys -a bottom -m 100 &
elif [ -z "$APP" ]; then
  $1
else
  kill "$APP_PID"
fi
