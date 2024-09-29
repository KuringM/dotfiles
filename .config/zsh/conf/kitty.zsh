#######################################################################
#                           Kitty terminal                            #
#######################################################################

# use Kitty shell_intergration feature: mouse move cursor...
if [[ -n $KITTY_INSTALLATION_DIR ]]; then
  KITTY_SHELL_INTEGRATION=enabled
  source -- "$KITTY_INSTALLATION_DIR"/shell-integration/zsh/kitty.zsh
fi
# unset KITTY_SHELL_INTEGRATION
