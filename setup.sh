#!/usr/bin/env bash

HOMEP="$HOME"
I3_DIR="$HOMEP/.config/i3"
COMPTON_DIR="$HOMEP/.config/compton"
ROFI_DIR="$HOMEP/.config/rofi"
GIT_REPO_DIR="$HOMEP/Git/i3-gnome"

if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 1>&2; exit 1
fi

echo "Adding repositories..."
dnf -y copr enable plambri/desktop-apps
dnf -y copr enable victoroliveira/gnome-flashback

echo "Installing required software..."
dnf -y install i3-gaps i3status i3lock feh compton rofi most ImageMagick make xterm

echo "Creating directories..."
if [ -d "$I3_DIR" ]; then mkdir -p "$I3_DIR"; fi
if [ -d "$COMPTON_DIR" ]; then mkdir -p "$COMPTON_DIR"; fi
if [ -d "$HOMEP/bin" ]; then mkdir -p "$HOMEP/bin"; fi
if [ -d "$GIT_REPO_DIR" ]; then mkdir -p "$GIT_REPO_DIR"; fi
if [ -d "$ROFI_DIR" ]; then mkdir -p "$ROFI_DIR"; fi

echo "Cloning and installing csxr's i3-gnome repository..."
git clone https://github.com/csxr/i3-gnome "$GIT_REPO_DIR"
cd "$GIT_REPO_DIR" || exit
make install

echo "Copying config files..."
cp config/i3_config "$I3_DIR/config"
cp config/compton_config "$COMPTON_DIR/config"
cp config/rofi_config "$ROFI_DIR/config"
cp config/Xresources "$HOMEP/.Xresources"
cp config/Xresources.molokai "$HOMEP/.Xresources.molokai"

echo "#include \"$HOMEP/.Xresources.molokai\"" >> "$HOMEP/.Xresources"

echo "Configuring .bashr..."
cat <<EOT >> "$HOMEP/.bashrc"
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
EOT

cat <<EOT >> /root/.bashrc
PS1="\[\033[1;31m\][\u@\h:\w]\\$ \[$(tput sgr0)\]"
EOT
