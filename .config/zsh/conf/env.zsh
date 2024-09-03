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

#  lua
export PATH="/opt/homebrew/opt/lua@5.3/bin:$PATH"
export LDFLAGS="-L/opt/homebrew/opt/lua@5.3/lib"
export CPPFLAGS="-I/opt/homebrew/opt/lua@5.3/include"
export PKG_CONFIG_PATH="/opt/homebrew/opt/lua@5.3/lib/pkgconfig"

# yarn
# alias yarn='yarn --use-yarnrc "$XDG_CONFIG_HOME/yarn/config"'

# homebrew
export PATH=$PATH:/opt/homebrew/bin

# path
export PATH=$PATH:$LOCALBIN
export PATH=$PATH:/usr/local/bin
export PATH=$PATH:$HOME/.local/bin

# zsh custom
# export TERM=xterm-256color
# export TERM=xterm-kitty
export TERM_ITALICS=true
export RANGER_LOAD_DEFAULT_RC="false"
export ZSH_AUTOSUGGEST_USE_ASYNC=1
export ZSH_AUTOSUGGEST_MANUAL_REBIND=1

# app env
export EDITOR=nvim
export CONFIG_DIR="$HOME/.config/jesseduffield/lazygit/"
#export MANPAGER="nvim +Man! --cmd 'let $NVIM_AS_PAGER=1'"
export MANPAGER="nvim +Man!"
