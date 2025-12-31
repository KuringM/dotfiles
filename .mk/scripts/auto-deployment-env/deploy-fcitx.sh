#! /usr/bin/bash

# Install some necessary module
sudo pacman -S fcitx5 fcitx5-chewing fcitx5-chinese-addons fcitx5-configtool fcitx5-gtk fcitx5-qt fcitx5-rime fcitx5-material-color

# Install thesaurus
yay -S fcitx5-pinyin-zhwiki fcitx5-pinyin-moegirl-rime

# Set environment variables for IM modules
echo "GTK_IM_MODULE DEFAULT=fcitx" >> ~/.pam_environment
echo "QT_IM_MODULE  DEFAULT=fcitx" >> ~/.pam_environment
echo "XMODIFIERS    DEFAULT=\@im=fcitx" >> ~/.pam_environment
echo "INPUT_METHOD  DEFAULT=fcitx" >> ~/.pam_environment
echo "SDL_IM_MODULE DEFAULT=fcitx" >> ~/.pam_environment
