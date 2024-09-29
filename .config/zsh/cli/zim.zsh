#######################################################################
#                               ZIM:FW                                #
#######################################################################

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

#######################################################################
#                        zmoudles: completion                         #
#######################################################################

# make dir for zsh cache
ZSH_CACHE="$HOME/.cache/zsh"
if [[ ! -d "$ZSH_CACHE" ]]; then
	mkdir -p $ZSH_CACHE
fi

# Add those zstyles to your ~/.zshrc before where the modules are initialized.
ZSH_COMPDUMP="$ZSH_CACHE/zcompdump"
zstyle ':zim:completion' dumpfile $ZSH_COMPDUMP
zstyle ':completion::complete:*' $ZSH_CACHE/zcompcache

# Initialize modules.
source ${ZIM_HOME}/init.zsh

#######################################################################
#                        zmoudles: environment                        #
#######################################################################

export HISTFILE=$ZSH_CACHE/zsh_history
if [[ ! -f "$HISFILE" ]]; then
	touch $HISTFILE
fi
HISTSIZE=20000
SAVEHIST=10000
# Remove older command from the history if a duplicate is to be added.
setopt HIST_IGNORE_ALL_DUPS

#######################################################################
#                       zmoudles: duration_info                       #
#######################################################################

setopt nopromptbang prompt{cr,percent,sp,subst}
zstyle ':zim:duration-info' threshold 0.5
zstyle ':zim:duration-info' format '%.4d s'
autoload -Uz add-zsh-hook
add-zsh-hook preexec duration-info-preexec
add-zsh-hook precmd duration-info-precmd
RPS1='${duration_info}'

#######################################################################
#               zmoudles: zsh-history-substring-search                #
#######################################################################

# Bind ^[[A/^[[B manually so up/down works both before and after zle-line-init
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
bindkey -M vicmd '^u' history-substring-search-up
bindkey -M vicmd '^e' history-substring-search-down
bindkey '^u' history-substring-search-up
bindkey '^e' history-substring-search-down

#######################################################################
#                 zmoudles: fast-syntax-highlighting                  #
#######################################################################

##  "zimfw not autoload this plugin"
source ${ZIM_HOME}/modules/fast-syntax-highlighting/F-Sy-H.plugin.zsh

#######################################################################
#                             zmoudles: k                             #
#######################################################################

if  ! which numfmt > /dev/null 2>&1; then
	brew install coreutils
fi

alias k="k -a"

#######################################################################
#                            zmoudles: zfm                            #
#######################################################################

export ZFM_BOOKMARKS_FILE=$ZSH_CACHE/zfm.txt
if [[ ! -f "$ZFM_BOOKMARKS_FILE" ]]; then
	touch $ZFM_BOOKMARKS_FILE
fi
# unbind "^p"
# bindkey -r '^P'

#######################################################################
#                           zmoudles: zsh-z                           #
#######################################################################

ZSHZ_DATA=$ZSH_CACHE/z
if [[ ! -f "$ZSHZ_DATA" ]]; then
	touch $ZSHZ_DATA
fi

#######################################################################
#                          zmoudles: fzf-tab                          #
#######################################################################

# use input as query string when completing zlua
zstyle ':fzf-tab:complete:_zlua:*' query-string input

# bindkey '^h' _complete_help
# use tmux popup (require tmux 3.2) to show results.
zstyle ':fzf-tab:*' fzf-command ftb-tmux-popup

# append custom keybindings to fzf, "Will not modify fzf configuration"
zstyle ':fzf-tab:*' fzf-bindings 'ctrl-e:down' 'ctrl-u:up' 'ctrl-l:clear-query'

# use of fzf's --preview option when using fzf-tab
if  ! which eza > /dev/null 2>&1; then
	brew install eza
fi
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always $realpath' # remember to use single quote here!!!
zstyle ':fzf-tab:*' query-string prefix input first

#######################################################################
#                    zmoudles: zsh-autosuggestions                    #
#######################################################################

export ZSH_AUTOSUGGEST_USE_ASYNC=1
export ZSH_AUTOSUGGEST_MANUAL_REBIND=1
# Use with kitty 'map ctrl+i send_text application \033[105;5u' and zimfw/input
bindkey "^[[105;5u" forward-char # same as bindkey "\033[105;5u" forward-char
