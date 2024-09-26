# zsh env
# use `zsh --sourcetrace --verbose` check configuration
ZSH_CACHE="$HOME/.cache/zsh"
if [[ ! -d "$ZSH_CACHE" ]]; then
	mkdir -p $ZSH_CACHE
fi


export HISTFILE=$ZSH_CACHE/zsh_history
if [[ ! -f "$HISFILE" ]]; then
	touch $HISTFILE
fi
# Remove older command from the history if a duplicate is to be added.
setopt HIST_IGNORE_ALL_DUPS

###############
#  setup zim  #
###############

export ZFM_BOOKMARKS_FILE=$ZSH_CACHE/zfm.txt
if [[ ! -f "$ZFM_BOOKMARKS_FILE" ]]; then
	touch $ZFM_BOOKMARKS_FILE
fi

# define zim evn
ZIM_CONFIG_FILE=~/.config/zsh/cli/zimrc
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

## zmoudles: completion Settings
##############################################################################
# Add the zstyles to your ~/.zshrc before where the modules are initialized. #
##############################################################################

ZSH_COMPDUMP="$ZSH_CACHE/zcompdump"
zstyle ':zim:completion' dumpfile $ZSH_COMPDUMP
zstyle ':completion::complete:*' $ZSH_CACHE/zcompcache

# Initialize modules.
source ${ZIM_HOME}/init.zsh


## zmoudles: zsh-history-substring-search
# Bind ^[[A/^[[B manually so up/down works both before and after zle-line-init
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
bindkey -M vicmd 'u' history-substring-search-up
bindkey -M vicmd 'e' history-substring-search-down
bindkey '^u' history-substring-search-up
bindkey '^e' history-substring-search-down

## zmoudles: fast-syntax-highlighting "zimfw not autoload this plugin"
source ${ZIM_HOME}/modules/fast-syntax-highlighting/F-Sy-H.plugin.zsh

## zmoudles: k
if  ! which numfmt > /dev/null 2>&1; then
	brew install coreutils
fi

## zmoudles: zsh-z
ZSHZ_DATA=$ZSH_CACHE/z
if [[ ! -f "$ZSHZ_DATA" ]]; then
	touch $ZSHZ_DATA
fi
