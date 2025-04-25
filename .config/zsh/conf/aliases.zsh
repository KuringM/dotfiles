#######################################################################
#                        Aliase some commands                         #
#######################################################################

alias c='clear'
alias cs='calcurse'
alias cdiff='colordiff'
alias kk='nvim .gitignore'
alias lg='lazygit'
alias lo='lsof -p $(fps) +w'
# alias ra='ranger'
# alias sra='sudo -E ranger'
alias ra='yazi'
alias sra='sudo -E yazi'
alias s='neofetch --kitty ~/MK/Wallpaper'
alias g='onefetch'
alias sudo='sudo -E'
alias t='tmux'
alias ta='tmux a'
alias vim='nvim'
alias n='nvim'
alias nu='nvim --headless "+Lazy! sync" +qa'
alias cman="man -M ~/Workspaces/manpages-zh/build/zh_CN"
alias icat="kitten icat"

#######################################################################
#                                 Git                                 #
#######################################################################

alias gc='git config credential.helper store'
alias gg='git clone'
alias gs='git config credential.helper store'

#######################################################################
#           Tracking dotfiles directly with Git and Lazygit           #
#######################################################################

alias cf='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
alias cfg='lazygit --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
alias cfs='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME status -u -s'
