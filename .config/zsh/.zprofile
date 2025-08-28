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
export XDG_RUNTIME_DIR=$XDG_CACHE_HOME

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
# export PATH=$PATH:/Library/Frameworks/Python.framework/Versions/3.10/bin
# export PATH=$PATH:$HOME/Library/Python/3.10/bin

# lua
export PATH="/opt/homebrew/opt/lua@5.3/bin:$PATH"
export LDFLAGS="-L/opt/homebrew/opt/lua@5.3/lib"
export CPPFLAGS="-I/opt/homebrew/opt/lua@5.3/include"
export PKG_CONFIG_PATH="/opt/homebrew/opt/lua@5.3/lib/pkgconfig"

# homebrew
export PATH="/opt/homebrew/bin:$PATH"
eval "$(brew shellenv)" # homebrew Completion
export HOMEBREW_AUTO_UPDATE_SECS=86400
export HOMEBREW_NO_ENV_HINTS=1

# clang
# export PATH=$PATH:/Library/Developer/CommandLineTools/usr/bin
export CPATH="/opt/homebrew/include"
export LIBRARY_PATH="/opt/homebrew/lib"

#######################################################################
#                            $HOME CLEANUP                            #
#######################################################################

# lazygit
export CONFIG_DIR="$HOME/.config/jesseduffield/lazygit/"

# less
export LESSHISTFILE="$XDG_CACHE_HOME/less/history"
if [[ ! -f "$LESSHISTFILE" ]] mkdir -p $XDG_CACHE_HOME/less && touch $LESSHISTFILE

# npm
export NPM_CONFIG_USERCONFIG=$HOME/.config/npm/npmrc

# yarn
YARNRC="$HOME/.config/yarn/yarnrc"
if [[ ! -f "$YARNRC" ]] mkdir -p $XDG_CONFIG_HOME/yarn && touch $YARNRC
alias yarn='yarn --use-yarnrc "$YARNRC"'

# ranger
export RANGER_LOAD_DEFAULT_RC="false"

# Rush#cargo
export CARGO_HOME="$XDG_DATA_HOME"/cargo
export PATH=$PATH:$CARGO_HOME/bin

# wget
# export WGETRC="$XDG_CONFIG_HOME/wgetrc"
alias wget="wget --hsts-file="$XDG_CACHE_HOME/wget-hsts""

# prettierd
# export PRETTIERD_DEFAULT_CONFIG="$XDG_CONFIG_HOME/prettierrc.yaml"

# yazi
# export YAZI_LOG=debug yazi

# rime_ls
# 用于编译
export LIBRIME_LIB_DIR=/usr/local/lib
export LIBRIME_INCLUDE_DIR=/usr/local/include
# 用于运行
export DYLD_LIBRARY_PATH=/usr/local/lib  # 最好放在~/.zshrc中, 记得修改~/.zshrc 后, source ~/.zshrc
