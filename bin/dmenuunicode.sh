#!/bin/sh

# The famous "get a menu of emojis to copy" script.

# Get user selection via dmenu from emoji file.
chosen=$(cut -d ';' -f1 ~/.local/bin//emoji | dmenu -n -i -l 30 -p '' --tb "#1a1a1a" --tf "#268bd2" --fb "#2E3440" --nb "#1a1a1a" --hb "#1a1a1a" --hf "#268bd2" -m $(swaymsg -r -t get_outputs | jq '. | reverse | to_entries | .[] | select(.value.focused == true) | .key') | sed "s/ .*//")

# Exit if none chosen.
[ -z "$chosen" ] && exit

echo "$chosen" | tr -d '\n' | wl-copy && notify-send "'$chosen' copied to clipboard." &

# If you run this command with an argument, it will automatically insert the
# character. Otherwise, show a message that the emoji has been copied.
#if [ -n "$1" ]; then
#	xdotool type "$chosen"
#else
#	echo "$chosen" | tr -d '\n' | wl-copy
#	notify-send "'$chosen' copied to clipboard." &
#fi
