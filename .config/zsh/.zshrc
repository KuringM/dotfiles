source ~/.config/zsh/conf/env.zsh
source ~/.config/zsh/conf/aliases.zsh
source ~/.config/zsh/conf/mappings.zsh
source ~/.config/zsh/conf/vi.zsh
source ~/.config/zsh/conf/fzf.zsh

###############
#  setup zim  #
###############

ZIM_CONFIG_FILE=~/.config/zsh/conf/zimrc
ZIM_HOME=~/.config/zim
# Download zimfw plugin manager if missing.
if [[ ! -e ${ZIM_HOME}/zimfw.zsh ]]; then
  curl -fsSL --create-dirs -o ${ZIM_HOME}/zimfw.zsh \
      https://github.com/zimfw/zimfw/releases/latest/download/zimfw.zsh
fi
# Install missing modules and update ${ZIM_HOME}/init.zsh if missing or outdated.
if [[ ! ${ZIM_HOME}/init.zsh -nt ${ZIM_CONFIG_FILE:-${ZDOTDIR:-${HOME}}/.zimrc} ]]; then
  source ${ZIM_HOME}/zimfw.zsh init -q
fi
source ${ZIM_HOME}/init.zsh

# Remove older command from the history if a duplicate is to be added.
setopt HIST_IGNORE_ALL_DUPS

## Plugins
# Bind ^[[A/^[[B manually so up/down works both before and after zle-line-init
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
bindkey -M vicmd 'u' history-substring-search-up
bindkey -M vicmd 'e' history-substring-search-down

bindkey '^P' history-substring-search-up
bindkey '^N' history-substring-search-down

# use Kitty shell_intergration feature: mouse move cursor...
if test -n "$KITTY_INSTALLATION_DIR"; then
	export KITTY_SHELL_INTEGRATION="enabled"
	autoload -Uz -- "$KITTY_INSTALLATION_DIR"/shell-integration/zsh/kitty-integration
	kitty-integration
	unfunction kitty-integration
fi

source ~/.config/zim/modules/fzf-tab/fzf-tab.plugin.zsh
autopair-init
#自定义欢迎语
neofetch --kitty ~/MK/Wallpaper
