#!/usr/bin/env bash

## Lockscreen script
## Lockicon downloaded from https://creazilla.com/nodes/58783-locked-emoji-clipart
## No modifications were made on the lockicon
## Lockicon License: https://creativecommons.org/licenses/by/4.0/

swaylock --daemonize --screenshots --clock --indicator \
  --indicator-radius 100 \
  --indicator-thickness 12 \
  --effect-blur 7x5 \
  --ring-color 2E3440 \
  --key-hl-color ECEFF4 \
  --line-color 88C0D0 \
  --inside-color 00000088 \
  --separator-color 00000000 \
  --datestr %Y-%m-%d \
  --text-color ECEFF4 \
  --text-caps-lock-color ECEFF4 \
  --show-failed-attempts \
  --fade-in 0.1 \
  --effect-scale 0.5 --effect-blur 8x3 --effect-scale 2 \
  --effect-vignette 0.5:0.5 \
  --effect-compose "1.5%,1.5%;-1x10%;$HOME/.config/sway/sway.d/lock.png"
