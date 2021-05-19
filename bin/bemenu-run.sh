#!/usr/bin/env bash

## Generic bemenu script. Will be run from other scripts to make sure, bemenu always looks the same

if [ -f "$HOME/.cache/wal/colors.sh" ]; then
  source $HOME/.cache/wal/colors.sh
else
  background='#1a1a1a'
  color5='#268bd2'
  #color6='#2E3440'
fi

BEMENU_ARGS=(-n -i -p '' --tb "$background" --tf "$color5" --fb "$background" --nb "$background" --hb "$background" --hf "$color5" -m $(swaymsg -r -t get_outputs | jq '. | reverse | to_entries | .[] | select(.value.focused == true) | .key') "$@")

if [ "$1" = 'dmenu' ]; then
  bemenu-run "${BEMENU_ARGS[@]}"
else
  bemenu "${BEMENU_ARGS[@]}"
fi
