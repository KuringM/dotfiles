# Install fzf and other cli progs
if ! which fzf > /dev/null 2>&1; then
	brew install fzf
	brew install fd
	brew install ripgrep
	brew install bat
fi

# set fzf default opts
_fzf_default_opts=(
	"--height 80%"
	"--tmux center,100%,50%"
	"--layout reverse"
	"--border thinblock"
	"--multi"
	"--wrap"
	"--info=inline-right"
	"--preview='$HOME/.config/zsh/cli/fzf/fzf-preview.sh {}'"
	"--preview-window='right:60%:wrap'"
	"--bind=change:top,ctrl-t:top,ctrl-e:down,ctrl-u:up,ctrl-l:clear-query,'ctrl-y:execute-silent(echo {+} | pbcopy)'"
	"--bind='f1:execute(man fzf),f2:toggle-preview,f3:execute(bat --style=numbers {} || less -f {}),f4:execute($EDITOR {})'"
)
export FZF_DEFAULT_OPTS="${_fzf_default_opts}"

_fzf_default_command=(
	# "fd --type f --type l --hidden"
	# "fd --type f --strip-cwd-prefix"
	"fd --type f --strip-cwd-prefix --hidden --follow --exclude .git"
)
export FZF_DEFAULT_COMMAND="$_fzf_default_command"

# Set up fzf three key bindings and fuzzy completion "CTRL_T, CRTL_R, ALT_C"
source <(fzf --zsh)

_fzf_ctrl_t_opts=(
  "--walker-skip .git,node_modules,target"
	# Preview file content using bat (https://github.com/sharkdp/bat)
  # "--preview 'bat -n --color=always {}'"
	# "--preview-window down:3:hidden:wrap"
  "--bind 'ctrl-/:change-preview-window(right|down|hidden|right)'"
)
export FZF_CTRL_T_OPTS="$_fzf_ctrl_t_opts"

_fzf_ctrl_r_opts=(
	# CTRL-Y to copy the command into clipboard using pbcopy
  "--bind 'ctrl-y:execute-silent(echo -n {2..} | pbcopy)+abort'"
  "--color header:italic"
  "--header 'Press CTRL-Y to copy command into clipboard'"
	"--preview-window hidden"
)
export FZF_CTRL_R_OPTS="$_fzf_ctrl_r_opts"

# Print tree structure in the preview window
_fzf_alt_c_opts=(
  "--walker-skip .git,node_modules,target"
  "--preview 'tree -C {}'"
)
export FZF_ALT_C_OPTS="$_fzf_alt_c_opts"
# Do not exit on end-of-file. "^d default colse terminal in zsh"
setopt IGNORE_EOF
bindkey '^d' fzf-cd-widget

find-in-file() {
	grep --line-buffered --color=never -r "" * | fzf --preview-window hidden
	# rg --line-buffered --color=never -r "" * | fzf --preview-window hidden
}
zle -N find-in-file
bindkey '^f' find-in-file

# Use \ as the trigger sequence instead of the default **
export FZF_COMPLETION_TRIGGER='\'

# load some scripts written with fzf
_fzf_fpath=${0:h}/fzf
fpath+=$_fzf_fpath
autoload -U $_fzf_fpath/*(.:t)
unset _fzf_fpath
