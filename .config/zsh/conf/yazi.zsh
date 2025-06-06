#######################################################################
#                                Yazi                                 #
#######################################################################

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
if [[  "$(ls -l $HOME/.config/yazi/plugins | grep "^d" | wc -l)" -le 1 ]]; then
	rm -f ~/.config/yazi/package.toml
	ya pack -a Rolv-Apneseth/starship # Starship prompt plugin for yazi
	#  ya pack -a yazi-rs/plugins:git # Show the status of Git file changes as linemode in the file list.
	git clone https://gitee.com/DreamMaoMao/git.yazi.git ~/.config/yazi/plugins/git.yazi # git message prompt plugin for Yazi,
	ya pack -a llanosrocas/yaziline # Simple lualine-like status line for yazi.
	ya pack -a h-hg/yamb # Yet another bookmarks plugins. It supports persistence, jumping by a key, jumping by fzf.
	ya pack -a "Sonico98/exifaudio" # Preview audio files metadata on yazi
	ya pack -a yazi-rs/plugins:smart-enter # Open files or enter directories all in one key!
fi

# auto install starship for yazi
if ! where starship > /dev/null 2>&1; then
	brew install starship
	brew install ffmpegthumbnailer
	brew install exiftool
fi

## configuration starship env variable
export STARSHIP_CONFIG="$HOME/.config/starship/starship.toml"
export STARSHIP_CACHE="$HOME/.cache/starship"

## Set up zsh to use starship "Theme"
# eval "$(starship init zsh)"


# Yazi 文件管理器：退出后 cd 到 Yazi 最后所在目录
function yazi-cd() {
  local tmpfile=$(mktemp)
  yazi --cwd-file="$tmpfile" "$@"
  if [[ -f "$tmpfile" ]] && [[ -s "$tmpfile" ]]; then
    cd "$(cat "$tmpfile")"
  fi
  rm -f "$tmpfile"
}
