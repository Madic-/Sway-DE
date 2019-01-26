#!/usr/bin/env bash

SCRIPT_DIR=$(cd $(dirname $0) && pwd)
I3_DIR="$HOME/.config/i3"
I3_BLOCKS_DIR="$I3_DIR/scripts"
COMPTON_DIR="$HOME/.config/compton"
ROFI_DIR="$HOME/.config/rofi"
GIT_REPO_DIR="$HOME/Git/i3-gnome"

echo "Adding repositories..."
sudo dnf -y copr enable pkgbot/pkgs
sudo dnf -y copr enable victoroliveira/gnome-flashback

echo -e "\nInstalling required software..."
sudo dnf -y install i3-gaps i3status i3lock feh compton rofi most ImageMagick make xterm gnome-flashback libgnome-keyring i3blocks fontawesome-fonts

echo -e "\nCreating required directories..."
if [ ! -d "$I3_DIR" ]; then mkdir -p "$I3_DIR"; fi
if [ ! -d "$COMPTON_DIR" ]; then mkdir -p "$COMPTON_DIR"; fi
if [ ! -d "$HOME/bin" ]; then mkdir -p "$HOME/bin"; fi
if [ ! -d "$GIT_REPO_DIR" ]; then mkdir -p "$GIT_REPO_DIR"; fi
if [ ! -d "$ROFI_DIR" ]; then mkdir -p "$ROFI_DIR"; fi
if [ ! -d "$I3_BLOCKS_DIR" ]; then mkdir -p "$I3_BLOCKS_DIR"; fi

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
ln -is "$SCRIPT_DIR/config/i3.conf" "$I3_DIR/config"
ln -is "$SCRIPT_DIR/config/i3status.conf" "$I3_DIR/i3status.conf"
ln -is "$SCRIPT_DIR/config/i3blocks.conf" "$I3_DIR/i3blocks.conf"
ln -is "$SCRIPT_DIR/config/compton.conf" "$COMPTON_DIR/config"
ln -is "$SCRIPT_DIR/config/rofi.conf" "$ROFI_DIR/config"
ln -is "$SCRIPT_DIR/config/Xresources.molokai" "$HOME/.Xresources.molokai"
cp "$SCRIPT_DIR/config/Xresources" "$HOME/.Xresources"

echo -e "\nDownloading i3blocks scripts..."
wget -q https://raw.githubusercontent.com/vivien/i3blocks-contrib/master/bandwidth3/bandwidth3 -O "$I3_BLOCKS_DIR/bandwidth3"
wget -q https://raw.githubusercontent.com/vivien/i3blocks-contrib/master/battery2/battery2 -O "$I3_BLOCKS_DIR/battery2"
wget -q https://raw.githubusercontent.com/vivien/i3blocks-contrib/master/calendar/calendar -O "$I3_BLOCKS_DIR/calendar"
#wget -q https://raw.githubusercontent.com/vivien/i3blocks-contrib/master/rofi-calendar/rofi-calendar -O "$I3_BLOCKS_DIR/rofi-calendar"

chmod +x "$I3_BLOCKS_DIR/bandwidth3"
chmod +x "$I3_BLOCKS_DIR/battery2"
chmod +x "$I3_BLOCKS_DIR/calendar"
#chmod +x "$I3_BLOCKS_DIR/rofi-calendar"

if ! grep -q "/.Xresources.molokai" "$HOME/.Xresources"; then
	echo "#include \"$HOME/.Xresources.molokai\"" >>"$HOME/.Xresources"
fi

if ! grep -q "i3-gnome-flashback" "$HOME/.bashrc"; then
	echo -e "\nConfiguring $HOME/.bashrc..."
	cat <<EOF | sudo tee -a "$HOME/.bashrc" >/dev/null

# i3-gnome-flashback config begin
PS1="\[\033[1;32m\][\u@\h:\w]\\$ \[$(tput sgr0)\]"
export PAGER=most
export EDITOR=nano

alias nano='nano -c'
alias en='sudo -i'
alias ll='ls -lah --group-directories-first'
alias mkdir='mkdir -pv'
alias wget='wget -c'
alias df='df -H'
alias du='du -ch'
# i3-gnome-flashback config end
EOF
fi

if ! sudo grep -q "i3-gnome-flashback" "/root/.bashrc"; then
	echo -e "\nConfiguring /root/.bashrc..."
	cat <<EOF | sudo tee -a /root/.bashrc >/dev/null

# i3-gnome-flashback config begin
PS1="\[\033[1;31m\][\u@\h:\w]\\$ \[$(tput sgr0)\]"
export PAGER=most
export EDITOR=nano

alias nano='nano -c'
alias en='sudo -i'
alias ll='ls -lah --group-directories-first'
alias mkdir='mkdir -pv'
alias wget='wget -c'
alias df='df -H'
alias du='du -ch'
# i3-gnome-flashback config end
EOF
fi

echo -e "\nAfter a reboot you can select on the login screen \"Gnome + i3\" as a new desktop environment."
