#!/usr/bin/env bash

case "$(echo -e " Lock\n Logout\n Reboot\n Shutdown" | "$HOME"/.local/bin/bemenu-run.sh -l 4 -p "Power:")" in
" Lock") ~/.local/bin/lock.sh ;;
" Logout") swaymsg exit ;;
" Reboot") systemctl reboot ;;
" Shutdown") systemctl poweroff ;;
esac
