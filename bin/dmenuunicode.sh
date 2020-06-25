#!/bin/sh
# Original from Luke Smith:
# https://github.com/LukeSmithxyz/voidrice/blob/master/.local/bin/dmenuunicode

# The famous "get a menu of emojis to copy" script.

# Get user selection via dmenu from emoji file.
#chosen=$(cut -d ';' -f1 ~/.local/bin//emoji | dmenu -n -i -l 30 -p '' --tb "#1a1a1a" --tf "#268bd2" --fb "#2E3440" --nb "#1a1a1a" --hb "#1a1a1a" --hf "#268bd2" -m $(swaymsg -r -t get_outputs | jq '. | reverse | to_entries | .[] | select(.value.focused == true) | .key') | sed "s/ .*//")
chosen=$(cut -d ';' -f1 ~/.local/bin/emoji | ~/.local/bin/bemenu-run.sh list | sed "s/ .*//")

# Exit if none chosen.
[ -z "$chosen" ] && exit

# If you run this command with an argument, it will automatically insert the
# character. Otherwise, show a message that the emoji has been copied.
#
# ydotool works only passwordless if the user has permissions to write to /dev/uinput
# https://github.com/ReimuNotMoe/ydotool/issues/25

if [ -x "$(command -v ydotool)" ] && [ -n "$1" ] && [ -w "/dev/uinput" ]; then
  echo "$chosen" | tr -d '\n' | wl-copy
  #notify-send "'$chosen' copied to clipboard and entered." &

  TERMINAL="$(swaymsg -r -t get_tree | jq -r '.. | (.nodes? // empty)[] | select(.focused==true) | .app_id')"
  if [ "$TERMINAL" = 'Alacritty' ]; then
    ydotool key ctrl+shift+v
  else
    ydotool key ctrl+v
  fi
else
  echo "$chosen" | tr -d '\n' | wl-copy
  notify-send "'$chosen' copied to clipboard." &
fi
