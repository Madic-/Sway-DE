#!/usr/bin/env bash

yay -S --noconfirm --answerdiff None pamac-aur
sudo pacman -S --noconfirm code remmina
sudo pacman -Rs --noconfirm accerciser gnome-books gnome-builder dconf-editor devhelp baobab evolution five-or-more four-in-a-row glade gnome-boxes gnome-characters gnome-chess gnome-clocks gnome-dictionary gnome-disk-utility gnome-font-viewer yelp ghex hitori gnome-klotski gnome-logs gnome-mahjongg gnome-mines gnome-nibbles gnome-robots gnome-sudoku gnome-system-monitor gnome-taquin gnome-tetravex gnome-usage epiphany iagno ipython lightsoff gnome-multi-writer gnome-nettool polari quadrapassel gnome-recipes simple-scan gnome-sound-recorder swell-foop sysprof tali gnome-todo xterm totem gnome-devel-docs gnome-getting-started-docs gnome-user-docs gnome-music vim gnome-photos

echo "Configurig VS Code..."
if [ ! -d "$HOME/bin" ]; then mkdir -p "$HOME/bin"; fi
ln -s $(which code) ~/bin/code
ln -s "$HOME/.config/Code - OSS" "$HOME/.config/Code"
