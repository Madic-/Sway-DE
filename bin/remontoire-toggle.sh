#!/usr/bin/env bash

## Shows a hotkey window (remontoire)
## If remontoire is running, kill it.  Otherwise start it.

remontoire_PID=$(pidof remontoire)

if [ -z "$remontoire_PID" ]; then
  /usr/bin/remontoire -c ~/.config/sway/sway.d/07_hotkeys.conf &
else
  kill $remontoire_PID
fi
