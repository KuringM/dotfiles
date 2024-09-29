# print "export ZDOTDIR=${HOME}/.config/zsh" > /etc/zshenv
# use `zsh --sourcetrace --verbose` check configuration
# check 'Completion is not working'
# autoload -Uz +X compinit
# functions[compinit]=$'print -u2 \'compinit being called at \'${funcfiletrace[1]}
# '${functions[compinit]}

#######################################################################
#                       zsh builtin environment                       #
#######################################################################

export SHELL_SESSIONS_DISABLE=1
export EDITOR=nvim
export MANPAGER="nvim +Man!"
export TERM_ITALICS=true

#######################################################################
#                    Append environment variables                     #
#######################################################################

# XDG Base Direcotry
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"

# path
export PATH=$PATH:$LOCALBIN
export PATH=$PATH:/usr/local/bin
export PATH=$PATH:$HOME/.local/bin

# go
#export GOROOT=/usr/local/go
export GOPATH=$HOME/Workspaces/prog/go
export GOBIN=$HOME/Workspaces/prog/go/bin
export PATH=$PATH:/usr/local/go/bin
export PATH=$PATH:$GOPATH/bin

# python
export PATH=$PATH:/Library/Frameworks/Python.framework/Versions/3.10/bin
export PATH=$PATH:$HOME/Library/Python/3.10/bin

# npm
export NPM_CONFIG_USERCONFIG=$HOME/.config/npm/npmrc

# lua
export PATH="/opt/homebrew/opt/lua@5.3/bin:$PATH"
export LDFLAGS="-L/opt/homebrew/opt/lua@5.3/lib"
export CPPFLAGS="-I/opt/homebrew/opt/lua@5.3/include"
export PKG_CONFIG_PATH="/opt/homebrew/opt/lua@5.3/lib/pkgconfig"

# yarn
# alias yarn='yarn --use-yarnrc "$HOME/.config/yarn/config"'

# homebrew
export PATH=$PATH:/opt/homebrew/bin

# ranger
export RANGER_LOAD_DEFAULT_RC="false"

#######################################################################
#                            $HOME CLEANUP                            #
#######################################################################

export CONFIG_DIR="$HOME/.config/jesseduffield/lazygit/"
export LESSHISTFILE="$XDG_CACHE_HOME/less/history"
if [[ ! -f "$LESSHISTFILE" ]];then
	mkdir -p $XDG_CACHE_HOME/less
	touch $LESSHISTFILE
fi
