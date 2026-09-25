.PHONY: install
install: install-vim install-zsh install-git install-tmux install-ssh install-clipimg-send

.PHONY: install-vim
install-vim:
	test -f ~/.vimrc || ln -s $(PWD)/vimrc ~/.vimrc
	test -d ~/.vim || ln -s $(PWD)/vim ~/.vim
	mkdir -p ~/.config
	test -L ~/.config/nvim || ln -s ~/.vim ~/.config/nvim

.PHONY: install-zsh
install-zsh:
	test -f ~/.zshrc || ln -s $(PWD)/zshrc ~/.zshrc
	test -f ~/.zshenv || ln -s $(PWD)/zshenv ~/.zshenv

.PHONY: install-git
install-git:
	test -f ~/.gitconfig || ln -s $(PWD)/gitconfig ~/.gitconfig
	test -f ~/.gitignore_global || ln -s $(PWD)/gitignore_global ~/.gitignore_global
	test -d ~/.git-template || ln -s $(PWD)/git-template ~/.git-template

.PHONY: install-tmux
install-tmux:
	test -f ~/.tmux.conf || ln -s $(PWD)/tmux.conf ~/.tmux.conf
	test -f ~/.tmux.conf.linux || ln -s $(PWD)/tmux.conf.linux ~/.tmux.conf.linux
	mkdir -p ~/.tmux
	test -f ~/.tmux/tmux-claude-watch || ln -s $(PWD)/tmux-claude-watch ~/.tmux/tmux-claude-watch

.PHONY: install-ssh
install-ssh:
	mkdir -p ~/.ssh && chmod 700 ~/.ssh
	test -f ~/.ssh/config || ln -s $(PWD)/sshconfig ~/.ssh/config

.PHONY: install-clipimg-send
install-clipimg-send:
	mkdir -p ~/.config/raycast/scripts
	test -L ~/.config/raycast/scripts/clipimg-send.sh || ln -s $(PWD)/clipimg-send/clipimg-send.sh ~/.config/raycast/scripts/clipimg-send.sh
	mkdir -p ~/bin
	test -L ~/bin/clipimg-send || ln -s $(PWD)/clipimg-send/clipimg-send.sh ~/bin/clipimg-send
