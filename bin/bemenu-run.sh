#!/bin/bash

BEMENU_ARGS=(-n -i -p '' --tb "#1a1a1a" --tf "#268bd2" --fb "#2E3440" --nb "#1a1a1a" --hb "#1a1a1a" --hf "#268bd2" -m $(swaymsg -r -t get_outputs | jq '. | reverse | to_entries | .[] | select(.value.focused == true) | .key'))

if [ "$1" = 'list' ]; then
  BEMENU_ARGS+=(-l 30)
  # can this "while ... do" be optimized?
  while read; do echo "$REPLY"; done | bemenu "${BEMENU_ARGS[@]}"
fi

if [ "$1" = 'dmenu' ]; then
  bemenu-run "${BEMENU_ARGS[@]}"
fi

# Test if stdin is not empty
#if [ test ! -t 0 ]; then
#fi
