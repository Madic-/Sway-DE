#!/bin/sh

set -e

ICON=$HOME/.local/share/icons/target
THUMB=$(playerctl -i firefox metadata --format '{{lc(mpris:artUrl)}}')
SONG=$(playerctl -i firefox metadata --format "{{ title }}\n{{ artist }} - {{ album }}")

if [ -n "$THUMB" ]; then
  convert "$THUMB" -flatten -thumbnail 256x256 "$ICON"
fi

notify-send -i "$ICON" "Now playing" "$SONG"
if [ -f "$ICON" ]; then rm "$ICON"; fi
