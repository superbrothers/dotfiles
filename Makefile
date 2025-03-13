.PHONY: install
install:
	test -f ~/.vimrc || ln -s $(PWD)/vimrc ~/.vimrc
	test -d ~/.vim || ln -s $(PWD)/vim ~/.vim
	test -f ~/.zshrc || ln -s $(PWD)/zshrc ~/.zshrc
	test -f ~/.zshenv || ln -s $(PWD)/zshenv ~/.zshenv
	test -f ~/.gitconfig || ln -s $(PWD)/gitconfig ~/.gitconfig
	test -d ~/.git-template || ln -s $(PWD)/git-template ~/.git-template
	test -f ~/.tmux.conf || ln -s $(PWD)/tmux.conf ~/.tmux.conf
	test -f ~/.tmux.conf.linux || ln -s $(PWD)/tmux.conf.linux ~/.tmux.conf.linux
	mkdir -p ~/.ssh && chmod 700 ~/.ssh
	test -f ~/.ssh/config || ln -s $(PWD)/sshconfig ~/.ssh/config
	ln -s ~/.vim ~/.config/nvim
