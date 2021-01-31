.PHONY: bundle
bundle:
	brew bundle --no-lock

.PHONY: install
install:
	ln -s $(PWD)/vimrc ~/.vimrc
	ln -s $(PWD)/vim ~/.vim
	ln -s $(PWD)/screenrc ~/.screenrc
	ln -s $(PWD)/zshrc ~/.zshrc
	ln -s $(PWD)/gitconfig ~/.gitconfig
	ln -s $(PWD)/git-template ~/.git-template

.PHONY: uninstall
uninstall:
	rm ~/.vimrc
	rm -r ~/.vim
	rm ~/.screenrc
	rm ~/.zshrc
	rm ~/.gitconfig
	rm -r ~/.git-template
