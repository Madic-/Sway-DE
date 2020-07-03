#!/usr/bin/env bash

## Starts, stops and shows status for screensharing

geometry() {
  windowGeometries=$(
    # `height - 1` is there because of: https://github.com/ammen99/wf-recorder/pull/56 (I could remove it if it's merged, maybe)
    swaymsg -t get_workspaces -r | jq -r '.[] | select(.focused) | .rect | "\(.x),\(.y) \(.width)x\(.height - 1)"'
    swaymsg -t get_outputs -r | jq -r '.[] | select(.active) | .rect | "\(.x),\(.y) \(.width)x\(.height)"'
  )
  geometry=$(slurp -b "#45858820" -c "#45858880" -w 3 -d <<<"$windowGeometries") || exit $?
  echo "$geometry"
}

{
  if [ "$1" == "stop" ]; then
    if pgrep ffplay >/dev/null; then
      pkill ffplay >/dev/null
    fi
    if pgrep wf-recorder >/dev/null; then
      pkill wf-recorder >/dev/null
    fi
    notify-send -t 2000 "Wayland recording has been stopped"
  elif [ "$1" == "is-recording" ]; then
    if pgrep wf-recorder >/dev/null; then
      notify-send -t 2000 "Wayland recording is up"
    else
      notify-send -t 2000 "No Wayland recording"
    fi
  else
    if ! pgrep wf-recorder >/dev/null; then
      geometry=$(geometry) || exit $?
      unset SDL_VIDEODRIVER
      wf-recorder -c rawvideo -x yuv420p -m avi -f >(ffplay -window_title Screenshare -f avi -) --geometry="$geometry" &
      sleep 0.5
      # a hack so FPS is not dropping
      swaymsg [title=Screenshare] floating enable, move position 1800 900
    fi
    notify-send -t 2000 "Wayland recording has been started"
  fi
} >~/.wayland-share-screen.log 2>&1
