#!/usr/bin/env bash

case "$(echo -e " Lock\n Logout\n Reboot\n Shutdown" | "$HOME"/.local/bin/bemenu-run.sh -l 4 -p "Power:")" in
" Lock") swaylock --screenshots --clock --indicator --indicator-radius 100 --indicator-thickness 12 --effect-blur 7x5 --ring-color 2E3440 --key-hl-color ECEFF4 --line-color 88C0D0 --inside-color 00000088 --separator-color 00000000 --datestr %Y-%m-%d --text-color ECEFF4 --text-caps-lock-color ECEFF4 ;;
" Logout") swaymsg exit ;;
" Reboot") systemctl reboot ;;
" Shutdown") systemctl poweroff ;;
esac
