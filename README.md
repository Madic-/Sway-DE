# Sway [![Maintenance](https://img.shields.io/maintenance/yes/2019.svg)]()

![First Rice](screen01.png)

This repository provides an i3 and a sway version of my Fedora desktop environment. Though the i3 environment is no longer supported and may at some day stop working.

The i3 version comes with gnome-flashback because it did support me with the sound, display and bluetooth configuration and supports thinks like dynamically changing the display in case I e.g. take my notebook out of the docking station.

The sway version comes without an underlying desktop environment, because it's not required. This readme only covers the sway version.

## Current setup

* **OS:** Fedora 29
* **Shell:** Bash
* **Wayland compositor:** Sway
* **Bar:** i3blocks
* **Launcher:** Rofi
* **Terminal:** gnome-terminal
* **GTK:** [Windows 10](https://www.gnome-look.org/p/1013482/)
* **Icons:** [Windows 10](https://github.com/B00merang-Artwork/Windows-10)

## Installation

Run setup-sway.sh. The most part of the script is independend and can be done on every linux distribution. There is only a small part, adding repositories and installing software, at the beginning of the script that is Fedora specific. This part can be easily extended. But only Fedora is tested by me.

During installation the script will do the following changes to the system:

* Add the following repos from fedora copr:

  * [pkgbot/pkgs](https://copr.fedorainfracloud.org/coprs/pkgbot/pkgs/) for the i3 environment

  * [knopki/desktop](https://copr.fedorainfracloud.org/coprs/knopki/desktop/) for gnome-flashback

* Install required software (see setup-sway.sh for details)

* Files from the config folder will be symlinked to the appropriate location

* Enables ssh-agent via systemd --user

* i3block scripts will be downloaded from [i3-contrib repository](https://github.com/vivien/i3blocks-contrib) to ~/bin/blocks

* Add entries to /root/.bashrc and ~/.bashrc

## Manual Setup

The GTK Theme and Icons need to be downloaded manually.

* ~/.config/gtk-3.0/settings.ini

```bash
[Settings]
gtk-theme-name = Windows-10-2.0.1
gtk-icon-theme-name = Windows-10
```

* ~/.gtkrc-2.0

```bash
gtk-theme-name = Windows-10-2.0.1
gtk-icon-theme-name = Windows-10
```