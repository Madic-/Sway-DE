#!/usr/bin/env bash

SCREENS=$(swaymsg -t get_outputs | jq -r '.[] | .name')
mapfile -t SCREENSA <<< "$SCREENS"

# sets my default monitor setup
swaymsg output "${SCREENSA[0]}" pos 0 0 res 1920x1080
swaymsg output "${SCREENSA[1]}" pos 1920 0 res 1920x1080
swaymsg output "${SCREENSA[2]}" pos 3840 0 res 1920x1080
