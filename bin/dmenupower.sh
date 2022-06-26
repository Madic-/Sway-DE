#!/usr/bin/env bash

## Shows a drop down menu with power options

case "$(echo -e " Exit sway\n Lock\n Power Off\n Reboot\n Restart kanshi\n⏲ Suspend then hibernate\n" | bemenu-run.sh -l 6 -p "Power:")" in
" Exit sway")
  swaymsg exit
  loginctl terminate-user $USER
  ;;
" Lock") lock.sh ;;
" Power Off") exec systemctl poweroff -i ;;
" Reboot") exec systemctl reboot ;;
" Restart kanshi") exec systemctl --user restart kanshi ;;
"⏲ Suspend then hibernate") exec systemctl suspend-then-hibernate ;;
esac
