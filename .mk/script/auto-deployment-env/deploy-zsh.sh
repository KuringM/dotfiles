mkdir -p "$HOME/.local/share/zsh/"
touch "$HOME/.local/share/zsh/history"
ln $HOME/.config/zsh/init/zshenv $HOME/.config/zsh/.zshenv
ln $HOME/.config/zsh/init/zshrc $HOME/.config/zsh/.zshrc
ln $HOME/.config/zsh/init/zlogin $HOME/.config/zsh/.zlogin
ln $HOME/.config/zsh/init/zimrc $HOME/.config/zsh/.zimrc
mkdir -p "$HOME/.config/zim/"
ln $HOME/.config/zsh/init/zimfw.zsh $HOME/.config/zim/zimfw.zsh
zimfw install
