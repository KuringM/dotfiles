#!/usr/bin/env bash

# For System
sudo pacman -S networkmanager nm-connection-editor network-manager-applet xfce4-power-manager acpi acpilight alsa-utils ntfs-3g bc
yay -S update-grub

# For Shell
sudo pacman -S zsh thefuck w3m wget fzf neofetch zip unzip htop ripgrep tree tmux duf tldr
sudo pacman -S ranger pandoc texlive-most youtube-dl python-pdftotext perl-image-exiftool mupdf
yay -S gotop-git

# For Display Manager, such as DWM KDE.
sudo pacman -S xorg-apps xorg-xinit xorg-server dmenu feh picom flameshot screenkey nautilus gnome-font-viewer ark
yay -S acpitool google-chrome lazygit haruna j4-dmenu-desktop xmenu

# Install Graphics drive
sudo pacman -S mesa lib32-mesa vulkan-intel lib32-vulkan-intel
sudo pacman -S nvidia nvidia-settings lib32-nvidia-utils nvidia-lts

# Install optmus-manager
yay -S optimus-manager optimus-manager-qt
sudo systemctl enable optimus-manager

# Install qv2ray
sudo pacman -S qv2ray-dev-git v2ray
yay -S cgproxy q2ray-plugin-ssr-dev-git
