#!/usr/bin/env bash
# Auto Rice Boostrapping Scripts (KARBS)
# Original author:https://github.com/LukeSmithxyz/LARBS
# License:

### OPTIONS AND VARIABLES ###

while getopts ":a:r:b:p:h" o; do case "${o}" in
	h) printf "Optional arguments for custom use:\\n  -r: Dotfiles repository (local file or url)\\n  -p: Dependencies and programs csv (local file or url)\\n  -a: AUR helper (must have pacman-like syntax)\\n  -h: Show this message\\n" && exit 1 ;;
	r) dotfilesrepo=${OPTARG} && git ls-remote "$dotfilesrepo" || exit 1 ;;
	b) repobranch=${OPTARG} ;;
	p) progsfile=${OPTARG} ;;
	a) aurhelper=${OPTARG} ;;
	*) printf "Invalid option: -%s\\n" "$OPTARG" && exit 1 ;;
esac done

[ -z "$dotfilesrepo" ] && dotfilesrepo="https://github.com/KuringMIN/Dotfiles.git"
[ -z "$progsfile" ] && progsfile="https://raw.githubusercontent.com/KuringMIN/KARBS/master/progs.csv"
[ -z "$aurhelper" ] && aurhelper="paru"
[ -z "$repobranch" ] && repobranch="master"

### FUNCTIONS ###

installpkg(){ pacman --noconfirm --needed -S "$1" >/dev/null 2>&1 ;}

error() { echo "ERROR: $1" ; exit 1; }

welcomemsg() { \
	dialog --title "Welcome!" --msgbox "Welcome to Kuring's Auto-Rice Bootstrapping Script!\\n\\nThis script will automatically install a fully-featured Linux desktop, which I use as my main machine.\\n\\n-Kuring" 10 60

	dialog --colors --title "Important Note!" --yes-label "All ready!" --no-label "Return..." --yesno "Be sure the computer you are using has current pacman updates and refreshed Arch keyrings.\\n\\nIf it does not, the installation of some programs might fail." 8 70
	}

getuserandpass() { \
	# Prompts user for new username an password.
	name=$(dialog --inputbox "First, please enter a name for the user account." 10 60 3>&1 1>&2 2>&3 3>&1) || exit 1
	while ! echo "$name" | grep -q "^[a-z_][a-z0-9_-]*$"; do
		name=$(dialog --no-cancel --inputbox "Username not valid. Give a username beginning with a letter, with only lowercase letters, - or _." 10 60 3>&1 1>&2 2>&3 3>&1)
	done
	pass1=$(dialog --no-cancel --passwordbox "Enter a password for that user." 10 60 3>&1 1>&2 2>&3 3>&1)
	pass2=$(dialog --no-cancel --passwordbox "Retype password." 10 60 3>&1 1>&2 2>&3 3>&1)
	while ! [ "$pass1" = "$pass2" ]; do
		unset pass2
		pass1=$(dialog --no-cancel --passwordbox "Passwords do not match.\\n\\nEnter password again." 10 60 3>&1 1>&2 2>&3 3>&1)
		pass2=$(dialog --no-cancel --passwordbox "Retype password." 10 60 3>&1 1>&2 2>&3 3>&1)
	done ;}

usercheck() { \
	! { id -u "$name" >/dev/null 2>&1; } ||
	dialog --colors --title "WARNING!" --yes-label "CONTINUE" --no-label "No wait..." --yesno "The user \`\\Z1$name\\Zn\` already exists on this system. KARBS can install for a user already existing, but it will \\Z1\\Zboverwrite\\Zn any conflicting settings/dotfiles on the user account.\\n\\nKARBS will \\Z1\\Zbnot\\Zn overwrite your user files, documents, videos, etc., so don't worry about that, but only click <CONTINUE> if you don't mind your settings being overwritten.\\n\\nNote also that KARBS will change $name's password to the one you just gave." 14 70
	}

preinstallmsg() { \
	dialog --title "Let's get this party started!" --yes-label "Let's go!" --no-label "No, nevermind!" --yesno "The rest of the installation will now be totally automated, so you can sit back and relax.\\n\\nIt will take some time, but when done, you can relax even more with your complete system.\\n\\nNow just press <Let's go!> and the system will begin installation!" 13 60 || { clear; exit 1; }
	}

adduserandpass() { \
	# Adds user `$name` with password $pass1.
	dialog --infobox "Adding user \"$name\"..." 4 50
	useradd -m -g wheel -s /bin/zsh "$name" >/dev/null 2>&1 ||
	usermod -a -G wheel "$name" && mkdir -p /home/"$name" && chown "$name":wheel /home/"$name"
	repodir="/home/$name/.local/src"; mkdir -p "$repodir"; chown -R "$name":wheel "$(dirname "$repodir")"
	echo "$name:$pass1" | chpasswd
	unset pass1 pass2 ;}

refreshkeys() { \
	dialog --infobox "Refreshing Arch Keyring..." 4 40
	pacman -Q artix-keyring >/dev/null 2>&1 && pacman --noconfirm -S artix-keyring artix-archlinux-support >/dev/null 2>&1
	pacman --noconfirm -S archlinux-keyring >/dev/null 2>&1
	}

newperms() { # Set special sudoers settings for install (or after).
	sed -i "/#KARBS/d" /etc/sudoers
	echo "$* #KARBS" >> /etc/sudoers ;}

manualinstall() { # Installs $1 manually if not installed. Used only for AUR helper here.
	[ -f "/usr/bin/$1" ] || (
	dialog --infobox "Installing \"$1\", an AUR helper..." 4 50
	cd /tmp || exit 1
	rm -rf /tmp/"$1"*
	curl -sO https://aur.archlinux.org/cgit/aur.git/snapshot/"$1".tar.gz &&
	sudo -u "$name" tar -xvf "$1".tar.gz >/dev/null 2>&1 &&
	cd "$1" &&
	sudo -u "$name" makepkg --noconfirm -si >/dev/null 2>&1 || return 1
	cd /tmp || return 1) ;}

maininstall() { # Installs all needed programs from main repo.
	dialog --title "KARBS Installation" --infobox "Installing \`$1\` ($n of $total). $1 $2" 5 70
	installpkg "$1"
	}

gitmakeinstall() {
	progname="$(basename "$1" .git)"
	dir="$repodir/$progname"
	dialog --title "KARBS Installation" --infobox "Installing \`$progname\` ($n of $total) via \`git\` and \`make\`. $(basename "$1") $2" 5 70
	sudo -u "$name" git clone --depth 1 "$1" "$dir" >/dev/null 2>&1 || { cd "$dir" || return 1 ; sudo -u "$name" git pull --force origin master;}
	cd "$dir" || exit 1
	make >/dev/null 2>&1
	make install >/dev/null 2>&1
	cd /tmp || return 1 ;}

mygitmakeinstall() {
	[ ! -d "$repodir/myrepos" ] && mkdir -p "$repodir/myrepos"
	progname="$(basename "$1" .git)"
	dir="$repodir/myrepos/$progname"
	dialog --title "KARBS Installation" --infobox "Installing MK's \`$progname\` ($n of $total) via \`git\` and \`make\`. $(basename "$1") $2" 5 70
	sudo -u "$name" git clone --depth 1 "$1" "$dir" >/dev/null 2>&1 || { cd "$dir" || return 1 ; sudo -u "$name" git pull --force origin master;}
	cd "$dir" || exit 1
	make >/dev/null 2>&1
	make install >/dev/null 2>&1
	cd /tmp || return 1 ;}

aurinstall() { \
	dialog --title "KARBS Installation" --infobox "Installing \`$1\` ($n of $total) from the AUR. $1 $2" 5 70
	echo "$aurinstalled" | grep -q "^$1$" && return 1
	sudo -u "$name" $aurhelper -S --noconfirm "$1" >/dev/null 2>&1
	}

pipinstall() { \
	dialog --title "KARBS Installation" --infobox "Installing the Python package \`$1\` ($n of $total). $1 $2" 5 70
	[ -x "$(command -v "pip")" ] || installpkg python-pip >/dev/null 2>&1
	yes | pip install "$1"
	}

pip2install() { \
	dialog --title "KARBS Installation" --infobox "Installing the Python package \`$1\` ($n of $total). $1 $2" 5 70
	[ -x "$(command -v "pip2")" ] || installpkg python2-pip >/dev/null 2>&1
	yes | pip2 install "$1"
	}

npminstall() {\
	dialog --title "KARBS Installation" --infobox "Installing the nodejs package \`$1\` ($n of $total). $1 $2" 5 70
	[ -x "$(command -v "npm")" ] || installpkg npm >/dev/null 2>&1
	yes | npm install -g "$1"
}

installationloop() { \
	([ -f "$progsfile" ] && cp "$progsfile" /tmp/progs.csv) || curl -Ls "$progsfile" | sed '/^#/d' > /tmp/progs.csv
	total=$(wc -l < /tmp/progs.csv)
	aurinstalled=$(pacman -Qqm)
	while IFS=, read -r tag program comment; do
		n=$((n+1))
		echo "$comment" | grep -q "^\".*\"$" && comment="$(echo "$comment" | sed "s/\(^\"\|\"$\)//g")"
		case "$tag" in
			"A") aurinstall "$program" "$comment" ;;
			"G") gitmakeinstall "$program" "$comment" ;;
			"M") mygitmakeinstall "$program" "$comment" ;;
			"P") pipinstall "$program" "$comment" ;;
			"P2") pip2install "$program" "$comment" ;;
			"N") npminstall "$program" "$comment" ;;
			*) maininstall "$program" "$comment" ;;
		esac
	done < /tmp/progs.csv ;}
	
putDotRepo() { # Downloads a Dotfiles gitrepo $1 and places the files in $2 only overwriting conflicts
	dialog --infobox "Downloading Dotfiles..." 4 60
	[ -z "$3" ] && branch="master" || branch="$repobranch"
	dir=$(mktemp -d)
	[ ! -d "$2" ] && mkdir -p "$2"
	chown "$name":wheel "$dir" "$2"
	sudo -u "$name" git clone --bare --recursive --single-branch -b "$branch" --depth 1 --recurse-submodules "$1" "$dir" >/dev/null 2>&1
	sudo -u "$name" cp -rfT "$dir" "$2"
	}

putgitrepo() { # Downloads a gitrepo $1 and places the files in $2 only overwriting conflicts
	dialog --infobox "Downloading and installing config files..." 4 60
	[ -z "$3" ] && branch="master" || branch="$repobranch"
	dir=$(mktemp -d)
	[ ! -d "$2" ] && mkdir -p "$2"
	chown "$name":wheel "$dir" "$2"
	sudo -u "$name" git clone --recursive  -b "$branch" --depth 1 --recurse-submodules "$1" "$dir" >/dev/null 2>&1
	sudo -u "$name" cp -rfT "$dir" "$2"
	}

systembeepoff() { dialog --infobox "Getting rid of that retarded error beep sound..." 10 50
	rmmod pcspkr
	echo "blacklist pcspkr" > /etc/modprobe.d/nobeep.conf ;}

finalize(){ \
	dialog --infobox "Preparing welcome message..." 4 50
	dialog --title "All done!" --msgbox "Congrats! Provided there were no hidden errors, the script completed successfully and all the programs and configuration files should be in place.\\n\\nTo run the new graphical environment, log out and log back in as your new user, then run the command \"startx\" to start the graphical environment (it will start automatically in tty1).\\n\\n.t Kuring" 12 80
	}

### THE ACTUAL SCRIPT ###

### This is how everything happens in an intuitive format and order.

# Check if user is root on Arch distro. Install dialog.
pacman --noconfirm --needed -Sy dialog || error "Are you sure you're running this as the root user, are on an Arch-based distribution and have an internet connection?"

# Welcome user and pick dotfiles.
welcomemsg || error "User exited."

# Get and verify username and password.
getuserandpass || error "User exited."

# Give warning if user already exists.
usercheck || error "User exited."

# Last chance for user to back out before install.
preinstallmsg || error "User exited."

### The rest of the script requires no user input.

# Refresh Arch keyrings.
refreshkeys || error "Error automatically refreshing Arch keyring. Consider doing so manually."

for x in curl base-devel git ntp zsh; do
	dialog --title "KARBS Installation" --infobox "Installing \`$x\` which is required to install and configure other programs." 5 70
	installpkg "$x"
done

dialog --title "LARBS Installation" --infobox "Synchronizing system time to ensure successful and secure installation of software..." 4 70
ntpdate 0.us.pool.ntp.org >/dev/null 2>&1

adduserandpass || error "Error adding username and/or password."

[ -f /etc/sudoers.pacnew ] && cp /etc/sudoers.pacnew /etc/sudoers # Just in case

# Allow user to run sudo without password. Since AUR programs must be installed
# in a fakeroot environment, this is required for all builds with AUR.
newperms "%wheel ALL=(ALL) NOPASSWD: ALL"

# Make pacman and paru colorful and adds eye candy on the progress bar because why not.
grep -q "^Color" /etc/pacman.conf || sed -i "s/^#Color$/Color/" /etc/pacman.conf
grep -q "ILoveCandy" /etc/pacman.conf || sed -i "/#VerbosePkgLists/a ILoveCandy" /etc/pacman.conf
# Make pacman supports multilib
grep -q "#[multilib]" /etc/pacman.conf || set -i "s/^#[multilib]$/[multilib]" /etc/pacman.conf
# Add archlinuxcn
grep -q '[archlinuxcn]' /etc/pacman.conf || printf '[archlinuxcn]
SigLevel = Optional TrustAll
Server = https://mirrors.ustc.edu.cn/archlinuxcn/$arch
Server = https://mirrors.tuna.tsinghua.edu.cn/archlinuxcn/$arch' >> /etc/pacman.conf

# Use all cores for compilation.
sed -i "s/-j2/-j$(nproc)/;s/^#MAKEFLAGS/MAKEFLAGS/" /etc/makepkg.conf

manualinstall $aurhelper || error "Failed to install AUR helper."
# chinese aus
[ $aurhelper = "yay"] && sudo -u "$name" yay --aururl "https://aur.tuna.tsinghua.edu.cn" --save
# The command that does all the installing. Reads the progs.csv file and
# installs each needed program the way required. Be sure to run this only after
# the user has been created and has priviledges to run sudo without a password
# and all build dependencies are installed.
installationloop

dialog --title "LARBS Installation" --infobox "Finally, installing \`libxft-bgra\` to enable color emoji in suckless software without crashes." 5 70
yes | sudo -u "$name" $aurhelper -S libxft-bgra-git >/dev/null 2>&1

# Install the dotfiles in the user's home directory
putDotRepo "$dotfilesrepo" "/home/$name/.myconf" "$repobranch"
sudo -u "$name" git --git-dir=/home/$name/.myconf/ --work-tree=/home/$name checkout

## Install nvim configuration and scripts
nvimrepo="https://github.com/KuringMIN/nvim.git"
scriptsrepo="https://github.com/KuringMIN/scripts.git"
putgitrepo "$nvimrepo" "/home/$name/.config/nvim" "$repobranch"
putgitrepo "$scriptsrepo" "/home/$name/scripts" "$repobranch"

# Most important command! Get rid of the beep!
systembeepoff

# Make zsh the default shell for the user. And install zimfw!
chsh -s /bin/zsh "$name" >/dev/null 2>&1
sudo -u "$name" mkdir -p "/home/$name/.local/share/zsh/"
sudo -u "$name" touch "/home/$name/.local/share/zsh/history"
sudo -u "$name" ln /home/$name/.config/zsh/init/zshenv /home/$name/.config/zsh/.zshenv
sudo -u "$name" ln /home/$name/.config/zsh/init/zshrc /home/$name/.config/zsh/.zshrc
sudo -u "$name" ln /home/$name/.config/zsh/init/zlogin /home/$name/.config/zsh/.zlogin
sudo -u "$name" ln /home/$name/.config/zsh/init/zimrc /home/$name/.config/zsh/.zimrc
sudo -u "$name" mkdir -p "/home/$name/.config/zim/"
sudo -u "$name" ln /home/$name/.config/zsh/init/zimfw.zsh /home/$name/.config/zim

# Make user dirs
sudo -u "$name" mkdir -p "/home/$name/user/Desktop"
sudo -u "$name" mkdir -p "/home/$name/user/Downloads"
sudo -u "$name" mkdir -p "/home/$name/user/Documents"
sudo -u "$name" mkdir -p "/home/$name/user/Templates"
sudo -u "$name" mkdir -p "/home/$name/user/Public"
sudo -u "$name" mkdir -p "/home/$name/user/Music"
sudo -u "$name" mkdir -p "/home/$name/user/Pictures"
sudo -u "$name" mkdir -p "/home/$name/user/Videos"

# dbus UUID must be generated for Artix runit.
dbus-uuidgen > /var/lib/dbus/machine-id

# Use system notifications for Brave on Artix
echo "export \$(dbus-launch)" > /etc/profile.d/dbus.sh

# create dwm.desktop
[ -d /usr/share/xsessions ] || mkdir /usr/share/xsessions
[ ! -f /usr/share/xsessions/dwm.desktop ] && printf '[Desktop Entry]
Encoding=UTF-8
Name=Dwm
Comment=the dynamic window manager
Exec=dwm
Icon=dwm
Type=XSession' > /usr/share/xsessions/dwm.desktop

# Tap to click
# [ ! -f /etc/X11/xorg.conf.d/40-libinput.conf ] && printf 'Section "InputClass"
#         Identifier "libinput touchpad catchall"
#         MatchIsTouchpad "on"
#         MatchDevicePath "/dev/input/event*"
#         Driver "libinput"
# 	# Enable left mouse button by tapping
# 	Option "Tapping" "on"
# EndSection' > /etc/X11/xorg.conf.d/40-libinput.conf

# Fix fluidsynth/pulseaudio issue.
grep -q "OTHER_OPTS='-a pulseaudio -m alsa_seq -r 48000'" /etc/conf.d/fluidsynth ||
	echo "OTHER_OPTS='-a pulseaudio -m alsa_seq -r 48000'" >> /etc/conf.d/fluidsynth

# Set some programs to start automatically

# Start/restart PulseAudio.
killall pulseaudio; sudo -u "$name" pulseaudio --start

# This line, overwriting the `newperms` command above will allow the user to run
# serveral important commands, `shutdown`, `reboot`, updating, etc. without a password.
newperms "%wheel ALL=(ALL) ALL #KARBS
%wheel ALL=(ALL) NOPASSWD: /usr/bin/shutdown,/usr/bin/reboot,/usr/bin/systemctl suspend,/usr/bin/wifi-menu,/usr/bin/mount,/usr/bin/umount,/usr/bin/pacman -Syu,/usr/bin/pacman -Syyu,/usr/bin/packer -Syu,/usr/bin/packer -Syyu,/usr/bin/systemctl restart NetworkManager,/usr/bin/rc-service NetworkManager restart,/usr/bin/pacman -Syyu --noconfirm,/usr/bin/loadkeys,/usr/bin/paru,/usr/bin/pacman -Syyuw --noconfirm"

# Last message! Install complete!
finalize
clear
