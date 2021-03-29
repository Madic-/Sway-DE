#!/usr/bin/env bash

## Shows a drop down menu with power options

case "$(echo -e " Exit sway\n Lock\n Power Off\n Reboot\n⏲ Suspend then hibernate\n" | "$HOME"/.local/bin/bemenu-run.sh -l 5 -p "Power:")" in
" Exit sway") swaymsg exit ;;
" Lock") ~/.local/bin/lock.sh ;;
" Power Off") exec systemctl poweroff -i ;;
" Reboot") exec systemctl reboot ;;
"⏲ Suspend then hibernate") exec systemctl suspend-then-hibernate ;;
esac
