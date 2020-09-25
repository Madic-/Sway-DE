#!/usr/bin/env bash

declare options=("bashrc
bash-ansible
bash-sway
bash-Zown"
)

choice=$(echo -e "${options[*]}" | "$HOME"/.local/bin/bemenu-run.sh -l 4 -p "Edit config file:")

case "$choice" in
bashrc) choice="$HOME/.bashrc" ;;
bash-ansible) choice="$HOME/.local/bin/bash/ansible.sh" ;;
bash-sway) choice="$HOME/.local/bin/bash/sway-de.sh" ;;
bash-Zown) choice="$HOME/.local/bin/bash/Zown.sh" ;;
*) exit 1 ;;
esac

alacritty -e nvim "$choice"
#pkill -WINCH nvim
