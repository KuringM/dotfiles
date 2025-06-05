# Install fzf and other cli progs
if ! which fzf > /dev/null 2>&1; then
	brew install fzf fd ripgrep bat
fi

#######################################################################
#                      FZF Envirronment Variables                     #
#######################################################################

_fzf_default_command=(
	# "fd --type f --type l --hidden"
	# "fd --type f --strip-cwd-prefix"
	"fd --type f --strip-cwd-prefix --hidden --follow --exclude .git -l"
)
export FZF_DEFAULT_COMMAND="$_fzf_default_command"

_fzf_default_opts=(
	"--tiebreak=index"
	"--height 80%"
	"--tmux center,100%,50%"
	"--layout reverse"
	"--border thinblock"
	"--multi"
	"--wrap"
	"--info=inline-right"
	"--preview='$HOME/.config/zsh/scripts/fzf-preview.sh {}'"
	"--preview-window='right:60%:wrap'"
	"--bind=change:top,ctrl-n:toggle,ctrl-u:up,ctrl-e:down,tab:down,ctrl-l:clear-query,ctrl-y:replace-query"
	"--bind='f1:execute(man fzf),f2:toggle-preview,f3:execute(bat --style=numbers {} || less -f {}),f4:execute($EDITOR {})'"
  "--bind 'ctrl-/:change-preview-window(right|down|hidden|right)'"
	"--bind 'alt-up:preview-page-up,alt-down:preview-page-down'"
	"--bind 'ctrl-c:execute-silent(echo {+} | pbcopy)+abort'"
	"--bind 'ctrl-s:toggle-sort'"
)
export FZF_DEFAULT_OPTS="${_fzf_default_opts}"

#######################################################################
#                    Key bindings for command-line                    #
#######################################################################

# Set up fzf three key bindings and fuzzy completion "CTRL_T, CRTL_R, ALT_C"
source <(fzf --zsh)

## fzf-file-widget ##
# Paste the selected files and directories onto the command-line
_fzf_ctrl_t_opts=(
  "--walker-skip .git,node_modules,target"
	"--prompt 'Paste '"
  "--header 'Paste the selected files and directories onto the command-line\nPress CTRL-Y to copy command into clipboard'"
)
export FZF_CTRL_T_OPTS="$_fzf_ctrl_t_opts"

## fzf-history-widget ##
# Paste the selected command from history onto the command-line
_fzf_ctrl_r_opts=(
  "--bind 'ctrl-y:execute-silent(echo -n {2..} | pbcopy)+abort'"
  "--color header:italic"
	"--prompt 'ZHistory '"
  "--header 'ZSH history\nPress CTRL-Y to copy command into clipboard'"
	"--preview-window hidden"
)
export FZF_CTRL_R_OPTS="$_fzf_ctrl_r_opts"

## fzf-cd-widget ##
# cd into the selected directory
_fzf_alt_c_opts=(
  "--walker-skip .git,node_modules,target"
  # "--preview 'tree -C {}'"
	"--preview 'eza -1 --color=always {}'"
	"--prompt 'cd '"
  "--header 'Press ENTER to copy dir name into readline'"
)
export FZF_ALT_C_OPTS="$_fzf_alt_c_opts"
# Do not exit on end-of-file. "^d default colse terminal in zsh"
setopt IGNORE_EOF
bindkey '^d' fzf-cd-widget

## Advanced fzf examples: Search for text in files
fzf-text-in-file() {
	rm -f /tmp/rg-fzf-{r,f}
	local RG_PREFIX="rg --hidden --column --line-number --no-heading --color=always --smart-case "
	local INITIAL_QUERY="${*:-}"
	fzf --ansi --disabled --query "$INITIAL_QUERY" \
			--bind "start:reload:$RG_PREFIX {q}" \
			--bind "change:reload:sleep 0.1; $RG_PREFIX {q} || true" \
			--bind 'ctrl-t:transform:[[ ! $FZF_PROMPT =~ fzf ]] &&
				echo "unbind(change)+change-prompt(1. fzf> )+enable-search+transform-query:echo \{q} > /tmp/rg-fzf-r; cat /tmp/rg-fzf-f" ||
				echo "rebind(change)+change-prompt(2. ripgrep> )+disable-search+transform-query:echo \{q} > /tmp/rg-fzf-f; cat /tmp/rg-fzf-r"' \
			--color "hl:-1:underline,hl+:-1:underline:reverse" \
			--prompt '1. fzf> ' \
			--delimiter : \
			--header 'CTRL-T: Switch between ripgrep/fzf' \
			--preview 'bat --color=always {1} --highlight-line {2}' \
			--preview-window 'up,60%,border-bottom,+{2}+3/3,~3' \
			--bind 'enter:become(nvim {1} +{2})'
}
zle -N fzf-text-in-file
bindkey '^f' fzf-text-in-file

#######################################################################
#                      Fuzzy completion for zsh                       #
#######################################################################

# Use \ as the trigger sequence instead of the default **
export FZF_COMPLETION_TRIGGER='\'
