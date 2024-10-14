#######################################################################
#                           Kitty terminal                            #
#######################################################################

# use Kitty shell_intergration feature: mouse move cursor...
if [[ -n $KITTY_INSTALLATION_DIR ]]; then
  KITTY_SHELL_INTEGRATION=enabled
  source -- "$KITTY_INSTALLATION_DIR"/shell-integration/zsh/kitty.zsh
fi
# unset KITTY_SHELL_INTEGRATION

# An alternative MacOS application icon for the wonderful Kitty terminal emulator. https://github.com/DinkDonk/kitty-icon.git
if [[ ! -e $XDG_CONFIG_HOME/kitty/kitty.app.icns ]]; then
	ln -s $XDG_CONFIG_HOME/kitty/themes/kitty-light.icns $XDG_CONFIG_HOME/kitty/kitty.app.icns
	rm /var/folders/*/*/*/com.apple.dock.iconcache; killall Dock
fi
