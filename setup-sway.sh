#!/usr/bin/env bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
SWAY_DIR="$HOME/.config/sway"
ROFI_DIR="$HOME/.config/rofi"
BLOCKS_DIR="$HOME/bin/blocks"
SYSTEMD_UDIR="$HOME/.config/systemd/user"

if [ -f /etc/os-release ]; then . /etc/os-release; OS=$NAME; fi

if [ "$OS" = Fedora ]; then
echo "Adding repositories..."
sudo dnf -y copr enable pkgbot/pkgs
sudo dnf -y copr enable knopki/desktop

echo -e "\nInstalling required software..."
sudo dnf -y install sway grim slurp yad most fontawesome-fonts blueberry pavucontrol i3blocks i3lock rofi libgnome-keyring polkit-gnome playerctl perl-Time-HiRes perl-Env
#i3-gaps i3status i3lock feh compton rofi most ImageMagick make gnome-flashback libgnome-keyring i3blocks fontawesome-fonts yad scrot xautolock flameshot
fi

echo -e "\nCreating required directories..."
if [ ! -d "$SWAY_DIR" ]; then mkdir -p "$SWAY_DIR"; fi
if [ ! -d "$ROFI_DIR" ]; then mkdir -p "$ROFI_DIR"; fi
if [ ! -d "$HOME/bin" ]; then mkdir -p "$HOME/bin"; fi
if [ ! -d "$BLOCKS_DIR" ]; then mkdir -p "$BLOCKS_DIR"; fi
if [ ! -d "$SYSTEMD_UDIR" ]; then mkdir -p "$SYSTEMD_UDIR"; fi

echo -e "\nCopying config files from $SCRIPT_DIR/config..."
cd "$SCRIPT_DIR" || exit
ln -s "$SCRIPT_DIR/config/sway.conf" "$SWAY_DIR/config"
ln -s "$SCRIPT_DIR/config/i3blocks.conf" "$BLOCKS_DIR/i3blocks.conf"
ln -s "$SCRIPT_DIR/config/rofi.conf" "$ROFI_DIR/config"
ln -s "$SCRIPT_DIR/bin/blocks/wlan" "$BLOCKS_DIR/wlan"
ln -s "$SCRIPT_DIR/bin/blocks/cpu_usage2" "$BLOCKS_DIR/cpu_usage2"
ln -s "$SCRIPT_DIR/bin/lock-sway" "$HOME/bin/lock-sway"
ln -s "$SCRIPT_DIR/bin/s" "$HOME/bin/s"
cp "$SCRIPT_DIR/config/ssh-agent.service" "$SYSTEMD_UDIR/"

echo -e "\nEnabling ssh-agent..."
sed s#HOME_VARIABLE#$HOME# "$SYSTEMD_UDIR/ssh-agent.service"
systemctl --user daemon-reload
systemctl --user enable ssh-agent.service

echo -e "\nDownloading i3blocks scripts..."
wget -q https://raw.githubusercontent.com/vivien/i3blocks-contrib/master/bandwidth3/bandwidth3 -O "$BLOCKS_DIR/bandwidth3"
wget -q https://raw.githubusercontent.com/vivien/i3blocks-contrib/master/battery2/battery2 -O "$BLOCKS_DIR/battery2"
wget -q https://raw.githubusercontent.com/vivien/i3blocks-contrib/master/calendar/calendar -O "$BLOCKS_DIR/calendar"
wget -q https://raw.githubusercontent.com/vivien/i3blocks-contrib/master/memory/memory -O "$BLOCKS_DIR/memory"
wget -q https://raw.githubusercontent.com/vivien/i3blocks-contrib/master/essid/essid -O "$BLOCKS_DIR/essid"
wget -q https://raw.githubusercontent.com/vivien/i3blocks-contrib/master/volume-pulseaudio/volume-pulseaudio -O "$BLOCKS_DIR/volume-pulseaudio"
wget -q https://raw.githubusercontent.com/vivien/i3blocks-contrib/master/mediaplayer/mediaplayer -O "$BLOCKS_DIR/mediaplayer"
wget -qO- https://github.com/cjbassi/gotop/releases/download/2.0.0/gotop_2.0.0_linux_amd64.tgz | tar xvz -C ~/bin/

chmod +x "$BLOCKS_DIR/bandwidth3"
chmod +x "$BLOCKS_DIR/battery2"
chmod +x "$BLOCKS_DIR/calendar"
chmod +x "$BLOCKS_DIR/essid"
chmod +x "$BLOCKS_DIR/memory"
chmod +x "$BLOCKS_DIR/volume-pulseaudio"
chmod +x "$BLOCKS_DIR/mediaplayer"

if ! grep -q "i3-gnome-flashback" "$HOME/.bashrc"; then
	echo -e "\nConfiguring $HOME/.bashrc..."
	cat <<EOF | sudo tee -a "$HOME/.bashrc" >/dev/null

# i3-gnome-flashback config begin
export GIT_PS1_SHOWDIRTYSTATE=true
export GIT_PS1_SHOWUNTRACKEDFILES=true
source /usr/share/git-core/contrib/completion/git-prompt.sh

PS1='\[\033[1;32m\][\u@\h:\w$(declare -F __git_ps1 &>/dev/null && __git_ps1 " (%s)")]\\$ \[\e[0m\]'
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

echo -e "\nAfter a reboot you can select on the login screen \"Sway\" as a new desktop environment."
