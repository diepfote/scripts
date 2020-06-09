#!/usr/bin/env bash

# gsettings set org.gnome.system.proxy mode manual
# gsettings set org.gnome.system.proxy.socks host '127.0.0.1'
# gsettings set org.gnome.system.proxy.socks port 7000

gsettings set org.cinnamon.desktop.default-applications.terminal exec uxterm
gsettings set org.gnome.desktop.media-handling automount false
gsettings set org.gnome.desktop.wm.keybindings raise "['F1']"

# nemo / nautilus
gsettings set org.gnome.desktop.background show-desktop-icons false
gsettings set org.nemo.desktop show-desktop-icons true

# disable sleep if on ac power
gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-ac-timeout 0

# wayland - allow applications to "grab" the keyboard
gsettings set org.gnome.mutter.wayland xwayland-grab-access-rules "['VirtualBox Machine']"

