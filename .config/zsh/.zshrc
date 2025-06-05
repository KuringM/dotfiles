#######################################################################
#                        Loading Configuration                        #
#######################################################################

# loading zsh Configuration
for cf in $HOME/.config/zsh/conf/*.zsh ; do
	source $cf
done

# load some scripts
_scripts_fpath=$HOME/.config/zsh/scripts
fpath+=$_scripts_fpath
autoload -U $_scripts_fpath/*(.:t)
unset _scripts_fpath

neofetch --kitty ~/MK/Wallpaper
