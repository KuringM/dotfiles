#!/usr/bin/env bash

# create directory
cd ~/
echo "Creating directorys"
mkdir ~/Github ~/prog ~/Pictures ~/Videos ~/Desktop ~/Documents ~/Downloads ~/Music ~/.zim ~/.config
echo "Done create directorys"

echo "Install dwm st"
# clone config st dwn wallpapers and install dwm st
git clone https://github.com/KuringMIN/.config ~/.config
git clone https://github.com/KuringMIN/st ~/prog/st
cd ~/prog/st
sudo make
sudo make clean install
cd ~/
git clone https://github.com/KuringMIN/dwm ~/prog/dwm
cd ~/prog/dwm
sudo make
sudo make clean install
echo "==========================="
echo "Finishing install dwn st!!!"
echo "==========================="

echo "Config .xinitrc"
cd ~/
echo "export LANG=zh_CN.UTF-8" >> ~/.xinitrc
echo "export LANGUAGE=zh_CN:en_US" >> ~/.xinitrc
echo "exec dwm" >> ~/.xinitrc

echo "Downloading wallpapers"
git clone https://github.com/KuringMIN/wallpapers ~/Pictures/wallpapers
cd ~/

# config zsh
echo "Config zsh"
sudo chsh -s /usr/bin/zsh
ln ~/.config/zsh/zshenv ~/.zshenv
ln ~/.config/zsh/zshrc ~/.zshrc
ln ~/.config/zsh/zlogin ~/.zlogin
ln ~/.config/zsh/zimrc ~/.zimrc
cp ~/.config/zsh/zimfw.zsh ~/.zim
zsh ~/.zim/zimfw.zsh install
zimfw install
zimfw update
zimfw upgrade
echo "Finishing"

/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
echo "config down zsh"
