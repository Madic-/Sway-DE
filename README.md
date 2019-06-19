# Sway [![Maintenance](https://img.shields.io/maintenance/yes/2019.svg)]()

![First Rice](screen01.png)

This repository provides a sway configuration of my Fedora desktop environment.

## Current setup

* **OS:** Fedora 30
* **Shell:** Bash
* **Wayland compositor:** Sway
* **Bar:** i3blocks
* **Launcher:** Rofi
* **Terminal:** gnome-terminal
* **GTK:** [Windows 10](https://www.gnome-look.org/p/1013482/)
* **Icons:** [Windows 10](https://github.com/B00merang-Artwork/Windows-10)

## Installation

Run setup-sway.sh. The most part of the script is independend and can be done on every linux distribution. There is only a small part, adding repositories and installing software, at the beginning of the script that is Fedora specific. This part can be easily extended. But only Fedora is tested by me.

The script also includes a first but not yet complete installation for arch.

During installation the script will do the following changes to the system:

* Add the following repos from fedora copr (though there are likely to be changed...):

  * [gumieri/sway](https://copr.fedorainfracloud.org/coprs/gumieri/sway/) for sway

  * [knopki/desktop](https://copr.fedorainfracloud.org/coprs/knopki/desktop/) for some tools

* Install required software (see setup-sway.sh for details)

* Files from the config folder will be symlinked to the appropriate location

* Enables ssh-agent via systemd --user

* i3block scripts will be downloaded from [i3-contrib repository](https://github.com/vivien/i3blocks-contrib) to ~/bin/blocks

* Downloads Windows-10 themes and icons to ~/.themes and ~/.icons

* Sets Windows-10 themes and icons in ~/.config/gtk-3.0/settings.ini and ~/.gtkrc-2.0

  * ~/.config/gtk-3.0/settings.ini

  ```bash
  [Settings]
  gtk-theme-name = Windows-10
  gtk-icon-theme-name = Windows-10
  ```

  * ~/.gtkrc-2.0

  ```bash
  gtk-theme-name = Windows-10
  gtk-icon-theme-name = Windows-10
  ```

* Add entries to /root/.bashrc and ~/.bashrc

## Hotkeys

This is not a list of all hotkeys but more for some none defaults. You can view all hotkeys in **config/sway.d/07_hotkeys.conf**.

| Action | Binding |
| --- | --- |
| Toggle Redshift | $mod+Shift+t |
| Make current focus fullscreen | $mod+f |
| Make current container fullscreen | $mod+Shift+f |
| Screenshot | $mod+Shift+s |

## Custom Sway configuration

In git all config/sway.d/99_*.conf files are ignored. You can add your own configuration there.

You can even create a folder with the hostname of your device and put device specific configuration in there.

```bash
mkdir -p $HOME/.config/sway/$(hostname)
```

### Device specific configuration

At the moment the following settings are considered device specific:

* Background (02_output.conf)

* Display (02_output.conf)

* Workspace to monitor assignment (03_workspace.conf)

* Bar (09_bar.conf)

The files do provide some commented examples. You can copy them to **$HOME/.config/sway/$(hostname)** and adjust them to your needs.

## Notes

* Currently the bar is commented because I'm testing [i3status-rust](https://github.com/greshake/i3status-rust) as an alternative bar. If you want to use it copy the file **config/sway.d/09_bar.conf** to something like **99_bar.conf** and uncomment all required settings.
