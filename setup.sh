#!/usr/bin/env bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
I3_DIR="$HOME/.config/i3"
I3_BLOCKS_DIR="$I3_DIR/scripts"
COMPTON_DIR="$HOME/.config/compton"
ROFI_DIR="$HOME/.config/rofi"
I3GNOME_GIT_REPO_DIR="$SCRIPT_DIR/../i3-gnome"
I3LOCK_GIT_DIR="$SCRIPT_DIR/../i3lock-fancy"

echo "Adding repositories..."
sudo dnf -y copr enable pkgbot/pkgs
sudo dnf -y copr enable victoroliveira/gnome-flashback

echo -e "\nInstalling required software..."
sudo dnf -y install i3-gaps i3status i3lock feh compton rofi most ImageMagick make gnome-flashback libgnome-keyring i3blocks fontawesome-fonts yad scrot xautolock

echo -e "\nCreating required directories..."
if [ ! -d "$I3_DIR" ]; then mkdir -p "$I3_DIR"; fi
if [ ! -d "$COMPTON_DIR" ]; then mkdir -p "$COMPTON_DIR"; fi
if [ ! -d "$HOME/bin" ]; then mkdir -p "$HOME/bin"; fi
if [ ! -d "$I3GNOME_GIT_REPO_DIR" ]; then mkdir -p "$I3GNOME_GIT_REPO_DIR"; fi
if [ ! -d "$ROFI_DIR" ]; then mkdir -p "$ROFI_DIR"; fi
if [ ! -d "$I3_BLOCKS_DIR" ]; then mkdir -p "$I3_BLOCKS_DIR"; fi
if [ ! -d "$I3LOCK_GIT_DIR" ]; then mkdir -p "$I3LOCK_GIT_DIR"; fi

echo -e "\nCloning and installing csxr's i3-gnome repository..."
cd "$I3GNOME_GIT_REPO_DIR" || exit
if [ -z "$(ls -A $I3GNOME_GIT_REPO_DIR)" ]; then
	git clone https://github.com/csxr/i3-gnome .
else
	git pull
fi
sudo make install

echo -e "\nCloning and installing meskarune's i3lock-fancy repository..."
cd "$I3LOCK_GIT_DIR" || exit
if [ -z "$(ls -A $I3LOCK_GIT_DIR)" ]; then
        git clone https://github.com/meskarune/i3lock-fancy.git .
else
    	git pull
fi
sudo make install

echo -e "\nCopying config files from $SCRIPT_DIR/config..."
cd "$SCRIPT_DIR" || exit
ln -s "$SCRIPT_DIR/config/i3.conf" "$I3_DIR/config"
ln -s "$SCRIPT_DIR/config/i3status.conf" "$I3_DIR/i3status.conf"
ln -s "$SCRIPT_DIR/config/i3blocks.conf" "$I3_DIR/i3blocks.conf"
ln -s "$SCRIPT_DIR/config/compton.conf" "$COMPTON_DIR/config"
ln -s "$SCRIPT_DIR/config/rofi.conf" "$ROFI_DIR/config"
ln -s "$SCRIPT_DIR/config/Xresources.molokai" "$HOME/.Xresources.molokai"
ln -s "$SCRIPT_DIR/bin/wlan" "$I3_BLOCKS_DIR/wlan"
cp "$SCRIPT_DIR/config/Xresources" "$HOME/.Xresources"

echo -e "\nDownloading i3blocks scripts..."
wget -q https://raw.githubusercontent.com/vivien/i3blocks-contrib/master/bandwidth3/bandwidth3 -O "$I3_BLOCKS_DIR/bandwidth3"
wget -q https://raw.githubusercontent.com/vivien/i3blocks-contrib/master/battery2/battery2 -O "$I3_BLOCKS_DIR/battery2"
wget -q https://raw.githubusercontent.com/vivien/i3blocks-contrib/master/calendar/calendar -O "$I3_BLOCKS_DIR/calendar"
wget -q https://raw.githubusercontent.com/vivien/i3blocks-contrib/master/memory/memory -O "$I3_BLOCKS_DIR/memory"
wget -q https://raw.githubusercontent.com/vivien/i3blocks-contrib/master/essid/essid -O "$I3_BLOCKS_DIR/essid"
wget -q https://raw.githubusercontent.com/vivien/i3blocks-contrib/master/volume-pulseaudio/volume-pulseaudio -O "$I3_BLOCKS_DIR/volume-pulseaudio"

chmod +x "$I3_BLOCKS_DIR/bandwidth3"
chmod +x "$I3_BLOCKS_DIR/battery2"
chmod +x "$I3_BLOCKS_DIR/calendar"
chmod +x "$I3_BLOCKS_DIR/essid"
chmod +x "$I3_BLOCKS_DIR/memory"
chmod +x "$I3_BLOCKS_DIR/volume-pulseaudio"

if ! grep -q "/.Xresources.molokai" "$HOME/.Xresources"; then
	echo "#include \"$HOME/.Xresources.molokai\"" >>"$HOME/.Xresources"
fi

if ! grep -q "i3-gnome-flashback" "$HOME/.bashrc"; then
	echo -e "\nConfiguring $HOME/.bashrc..."
	cat <<EOF | sudo tee -a "$HOME/.bashrc" >/dev/null

# i3-gnome-flashback config begin
export GIT_PS1_SHOWDIRTYSTATE=true
export GIT_PS1_SHOWUNTRACKEDFILES=true
source /usr/share/git-core/contrib/completion/git-prompt.sh

PS1='\[\033[1;32m\][\u@\h:\w$(declare -F __git_ps1 &>/dev/null && __git_ps1 " (%s)")]\$ \[^[(B^[[m\]'
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
