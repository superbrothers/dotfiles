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

.PHONY: uninstall
uninstall:
	rm ~/.vimrc
	rm ~/.vim
	rm ~/.zshrc
	rm ~/.gitconfig
	rm ~/.git-template
	rm ~/.tmux.conf
	rm ~/.ssh/config
