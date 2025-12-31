# install yay for archlinux
git clone https://aur.archlinux.org/yay.git ~/Github
cd /Github/yay
makepkg -si
cd ~/

echo "Installing yay done!!!"

# change software source
yay --aururl "https://aur.tuna.tsinghua.edu.cn" --save

# set achlinucn on
sudo echo "[archlinuxcn]" >> /etc/pacman.conf
sudo echo "SigLevel = Optional TrustAll" >> /etc/pacman.conf
sudo echo "Server = https://mirrors.ustc.edu.cn/archlinuxcn/\$arch" >> /etc/pacman.conf
sudo echo "Server = https://mirrors.tuna.tsinghua.edu.cn/archlinuxcn/\$arch" >> /etc/pacman.conf
