#!/bin/sh

set -e

ICON=$HOME/.local/share/icons/target
THUMB=$(playerctl metadata --format '{{lc(mpris:artUrl)}}')
SONG=$(playerctl metadata --format "{{ title }}\n{{ artist }} - {{ album }}")

if [ -n "$THUMB" ]; then
  convert "$THUMB" -flatten -thumbnail 256x256 "$ICON"
fi

notify-send -i "$ICON" "Now playing" "$SONG"
