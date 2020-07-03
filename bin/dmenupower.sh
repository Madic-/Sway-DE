#!/usr/bin/env bash

## Shows a drop down menu with power options

case "$(echo -e " Exit sway\n Lock\n Power Off\n Reboot" | "$HOME"/.local/bin/bemenu-run.sh -l 4 -p "Power:")" in
" Exit sway") swaymsg exit ;;
" Lock") ~/.local/bin/lock.sh ;;
" Power Off") systemctl poweroff ;;
" Reboot") systemctl reboot ;;
esac
