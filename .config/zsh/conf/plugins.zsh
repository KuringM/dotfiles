export PLUG_DIR=$ZIM_HOME
if [[ ! -d $PLUG_DIR ]]; then
	curl -fsSL https://raw.githubusercontent.com/zimfw/install/master/install.zsh | zsh
	rm ~/.config/zsh/.zimrc
	rm ~/.config/zsh/.zshrc
	ln -s ~/.config/zsh/init/zimrc ~/.config/zsh/.zimrc
	ln -s ~/.config/zsh/init/zshrc ~/.config/zsh/.zshrc
fi
