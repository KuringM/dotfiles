#######################################################################
#                   key binding for zsh insert mode                   #
#######################################################################

# `binding -L` output in form of bindkey commands

bindkey "^l" backward-delete-word
bindkey "^n" backward-kill-line

#######################################################################
#                     Key binding for zsh VI mode                     #
#######################################################################

# `bindkey -a` to show all vicmd keymap

bindkey -v # Selects keymap ‘vicmd’ for any operations by the current command
bindkey -M vicmd "k" vi-insert
bindkey -M vicmd "K" vi-insert-bol
bindkey -M vicmd "n" vi-backward-char
bindkey -M vicmd "i" vi-forward-char
bindkey -M vicmd "N" vi-beginning-of-line
bindkey -M vicmd "I" vi-end-of-line
bindkey -M vicmd "e" down-line-or-history
bindkey -M vicmd "u" up-line-or-history
bindkey -M vicmd "l" vi-undo-change
bindkey -M vicmd "L" undo
bindkey -M vicmd "r" redo
# bindkey -M vicmd "-" vi-rev-repeat-search
bindkey -M vicmd "=" vi-repeat-search
bindkey -M vicmd "h" vi-forward-word-end

#######################################################################
#                         key binding for CLI                         #
#######################################################################

function zle_eval {
    echo -en "\e[2K\r"
    eval "$@"
    zle redisplay
}

function openlazygit {
    zle_eval lazygit
}

zle -N openlazygit; bindkey "^G" openlazygit
