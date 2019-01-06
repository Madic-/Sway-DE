#!/usr/bin/env bash

SCRIPT_DIR=$(cd $(dirname $0) && pwd)
I3_DIR="$HOME/.config/i3"
COMPTON_DIR="$HOME/.config/compton"
ROFI_DIR="$HOME/.config/rofi"
GIT_REPO_DIR="$HOME/Git/i3-gnome"

echo "Adding repositories..."
sudo dnf -y copr enable plambri/desktop-apps
sudo dnf -y copr enable victoroliveira/gnome-flashback

echo -e "\nInstalling required software..."
sudo dnf -y install i3-gaps i3status i3lock feh compton rofi most ImageMagick make xterm gnome-flashback

echo -e "\nCreating required directories..."
if [ ! -d "$I3_DIR" ]; then mkdir -p "$I3_DIR"; fi
if [ ! -d "$COMPTON_DIR" ]; then mkdir -p "$COMPTON_DIR"; fi
if [ ! -d "$HOMEP/bin" ]; then mkdir -p "$HOMEP/bin"; fi
if [ ! -d "$GIT_REPO_DIR" ]; then mkdir -p "$GIT_REPO_DIR"; fi
if [ ! -d "$ROFI_DIR" ]; then mkdir -p "$ROFI_DIR"; fi

echo -e "\nCloning and installing csxr's i3-gnome repository..."
cd "$GIT_REPO_DIR" || exit
if [ -z "$(ls -A $GIT_REPO_DIR)" ]; then
  git clone https://github.com/csxr/i3-gnome .
else
  git pull https://github.com/csxr/i3-gnome
fi
sudo make install

echo -e "\nCopying config files from $SCRIPT_DIR/config..."
cd "$SCRIPT_DIR"
cp "$SCRIPT_DIR/config/i3_config" "$I3_DIR/config"
cp "$SCRIPT_DIR/config/compton_config" "$COMPTON_DIR/config"
cp "$SCRIPT_DIR/config/rofi_config" "$ROFI_DIR/config"
cp "$SCRIPT_DIR/config/Xresources" "$HOME/.Xresources"
cp "$SCRIPT_DIR/config/Xresources.molokai" "$HOME/.Xresources.molokai"

if ! grep -q "/.Xresources.molokai" "$HOME/.Xresources"; then
  echo "#include \"$HOME/.Xresources.molokai\"" >> "$HOME/.Xresources"
fi

if ! grep -q "i3-gnome-flashback" "$HOME/.bashrc"; then
  echo -e "\nConfiguring $HOME/.bashrc..."
  cat <<EOF | sudo tee -a "$HOME/.bashrc" > /dev/null

# i3-gnome-flashback config begin
PS1="\[\033[1;32m\][\u@\h:\w]\\$ \[$(tput sgr0)\]"
export PAGER=most
export EDITOR=nano

alias nano="nano -c"
alias en="sudo -i"
alias ll="ls -lah --group-directories-first"
alias mkdir="mkdir -pv"
alias wget='wget -c'
alias df='df -H'
alias du='du -ch'
# i3-gnome-flashback config end
EOF
fi

if ! sudo grep -q "i3-gnome-flashback" "/root/.bashrc"; then
  echo -e "\nConfiguring /root/.bashrc..."
  cat <<EOF | sudo tee -a /root/.bashrc > /dev/null

# i3-gnome-flashback config begin
PS1="\[\033[1;31m\][\u@\h:\w]\\$ \[$(tput sgr0)\]"
export PAGER=most
export EDITOR=nano

alias nano="nano -c"
alias en="sudo -i"
alias ll="ls -lah --group-directories-first"
alias mkdir="mkdir -pv"
alias wget='wget -c'
alias df='df -H'
alias du='du -ch'
# i3-gnome-flashback config end
EOF
fi
