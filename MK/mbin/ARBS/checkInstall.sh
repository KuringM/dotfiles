#!/usr/bin/env bash
progsfile="./progs.csv"

# check github install
checkGithubinstall(){
:		${1#https://github.com/*/}
:		${_%.git}
a=$_
}

checkInstallationloop() { \
	[ -f /tmp/progs.csv ] && rm /tmp/progs.csv
	[ -f "$progsfile" ] && sed '/^#/d' $progsfile > /tmp/progs.csv
	while IFS=, read -r tag program comment; do
		case "$tag" in
			"A") pacman -Qq "$program" >/dev/null 2>&1 || echo "$program not install in AUR " ;;
			"G") checkGithubinstall "$program"; (ls ~/.local/src/ | grep "$a") >/dev/null 2>&1 || echo "$a not find in .local/src" ;;
			"P") (pip list | grep "$program") >/dev/null 2>&1 || echo "$program not install in pip" ;;
			"P2") (pip2 list | grep "$program") >/dev/null 2>&1 || echo "$program not install in pip2" ;;
			"N") npm list -g "$program" >/dev/null 2>&1 || echo "$program not install in npm" ;;
			*) pacman -Qqn $program >/dev/null 2>&1 || echo "$program not install in pacman" ;;
		esac
	done < /tmp/progs.csv ;}
	
checkInstallationloop

