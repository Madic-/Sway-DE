#!/usr/bin/env bash
###
### Taken from u/StrangeAstronomer
### https://www.reddit.com/r/swaywm/comments/ljl0dh/keeping_secrets_secret_with_keepassxc_clipman_and/

app_id=$(swaymsg -t get_tree | jq -r '.. | select(.type?) | select(.focused==true) | .app_id')
if [[ $app_id != "org.keepassxc.KeePassXC" ]]; then
  # --no-persist so that we preserve rich text:
  clipman store --no-persist
fi
