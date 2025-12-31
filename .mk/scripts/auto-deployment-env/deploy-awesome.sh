#!/usr/bin/env bash

# awesome
yay -S awesome-git

# Install dependencies and enable services
yay -S rofi lm_sensors acpid jq fortune-mod redshift mpd mpc maim feh light-git pulseaudio inotify-tools xdotool

# For automatically launching mpd on login
systemctl --user enable mpd.service
systemctl --user start mpd.service
# For charger plug/unplug events (if you have a battery)
sudo systemctl enable acpid.service
sudo systemctl start acpid.service

# Install needes fonts
# typicons
# ttf-material-design-icons
# icomoon 
yay -S ttf-typicons ttf-all-the-icons ttf-icomoon

# My custom Iosevka build
# Anka/Coder
# Google Sans 
# Roboto Condensed
# San Francisco Display
yay -S ttf-iosevka-custom-git ttf-anka-coder ttf-google-sans ttf-roboto otf-san-francisco 

