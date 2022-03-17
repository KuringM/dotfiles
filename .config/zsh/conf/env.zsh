export LOCALPROG=$HOME/prog
# go 
export GOROOT=/usr/local/go
export GOPATH=$HOME/prog/go
export GOBIN=$HOME/prog/go/bin
export PATH=$PATH:/usr/local/go/bin
export PATH=$PATH:$GOPATH/bin

#npm
export NPM_CONFIG_USERCONFIG=$XDG_CONFIG_HOME/npm/npmrc

#yarn
alias yarn='yarn --use-yarnrc "$XDG_CONFIG_HOME/yarn/config"'

# path
export PATH=$PATH:$LOCALBIN
export PATH=$PATH:/usr/local/bin
export PATH=$PATH:$HOME/.local/bin

# applicantion
export W3M_DIR=$XDG_CONFIG_HOME/w3m

#zsh custom
export TERM=xterm-256color
export TERM_ITALICS=true
export RANGER_LOAD_DEFAULT_RC="false"
export ZSH_AUTOSUGGEST_USE_ASYNC=1
export ZSH_AUTOSUGGEST_MANUAL_REBIND=1
