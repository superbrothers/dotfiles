.PHONY: bundle
bundle:
	brew bundle --no-lock

.PHONY: install
install:
	ln -s $(PWD)/vimrc ~/.vimrc
	ln -s $(PWD)/vim ~/.vim
	ln -s $(PWD)/zshrc ~/.zshrc
	ln -s $(PWD)/gitconfig ~/.gitconfig
	ln -s $(PWD)/git-template ~/.git-template
	ln -s $(PWD)/tmux.conf ~/.tmux.conf
	mkdir -p ~/.ssh && chmod 700 ~/.ssh
	ln -s $(PWD)/sshconfig ~/.ssh/config
	mkdir -p ~/.config/alacritty
	ln -s $(PWD)/alacritty.yml ~/.config/alacritty/alacritty.yml

.PHONY: uninstall
uninstall:
	rm -f ~/.vimrc
	rm -f ~/.vim
	rm -f ~/.zshrc
	rm -f ~/.gitconfig
	rm -f ~/.git-template
	rm -f ~/.tmux.conf
	rm -f ~/.ssh/config
	rm -f ~/.config/alacritty/alacritty.yml
