export PLUG_DIR=$ZIM_HOME
if [[ ! -d $PLUG_DIR ]]; then
	curl -fsSL https://raw.githubusercontent.com/zimfw/install/master/install.zsh | zsh
	rm ~/.config/zsh/.zimrc
	rm ~/.config/zsh/.zshrc
	ln -s ~/.config/zsh/conf/zimrc ~/.config/zsh/.zimrc
	ln -s ~/.config/zsh/conf/zshrc ~/.config/zsh/.zshrc
fi
