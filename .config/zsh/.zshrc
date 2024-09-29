#######################################################################
#                        Loading Configuration                        #
#######################################################################

for cf in $HOME/.config/zsh/conf/*.zsh ; do
	source $cf
done

neofetch --kitty ~/MK/Wallpaper
