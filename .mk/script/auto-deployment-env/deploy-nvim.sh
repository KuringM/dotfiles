#! /usr/bin/bash

# clone my comfig from github
git clone https://github.com/KuingMIN/nvim ~/.config

# install some necessary module
# python pip , nodejs npm yarn , ruby ...
sudo pacman -S python python2 python-pip python2-pip nodejs npm yarn ruby the_silver_searcher figlet xclip ctags xdg-utils curl nodejs

# install neovim for python nodejs ruby
pip install pynvim debugpy ueberzug
pip2 install pynvim

sudo npm install -g neovim
yarn global add neovim
gem install neovim

# markdonw support
pip install --user smdv
sudo npm install -g instant-markdown-d

# install neovim-nightly-git in aur
yay -S neovim-nightly-git
