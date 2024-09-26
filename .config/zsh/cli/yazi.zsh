# Setup yazi

# auto install yazi
if ! where yazi > /dev/null 2>&1; then
	brew install yazi
fi

# set yamb bookmark dir path
YAZI_DATA="$HOME/.local/share/yazi"
if [[ ! -d "$YAZI_DATA" ]]; then
	mkdir -p $YAZI_DATA
fi

# Install yazi plugins
if [[ ! -e "$HOME/.config/yazi/plugins/git.yazi/init.lua" ]]; then
	rm -f ~/.config/yazi/package.toml
	ya pack -a Rolv-Apneseth/starship
#  ya pack -a yazi-rs/plugins:git
	git clone https://gitee.com/DreamMaoMao/git.yazi.git ~/.config/yazi/plugins/git.yazi
	ya pack -a llanosrocas/yaziline
	ya pack -a h-hg/yamb
fi

# auto install starship for yazi
if ! where starship > /dev/null 2>&1; then
	brew install starship
fi

## configuration starship env variable
export STARSHIP_CONFIG="$HOME/.config/starship/starship.toml"
export STARSHIP_CACHE="$HOME/.cache/starship"

## Set up zsh to use starship "Theme"
# eval "$(starship init zsh)"
