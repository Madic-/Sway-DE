#!/usr/bin/env bash

alacritty-wal.sh
pywalfox update
systemctl reload --user waybar
systemctl reload --user mako
systemctl restart --user kanshi
notify-send -t 0 "Theme changed.
Click to dismiss"
