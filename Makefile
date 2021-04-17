ifeq ($(shell uname),Darwin)
BREWFILE_PATH = Brewfile
else
BREWFILE_PATH = Brewfile.linux
endif

.PHONY: bundle
bundle:
	brew bundle --no-lock --file $(BREWFILE_PATH)

.PHONY: sync
sync:
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
	mkdir -p ~/.config/alacritty
	test -f ~/.config/alacritty/alacritty.yml || ln -s $(PWD)/alacritty.yml ~/.config/alacritty/alacritty.yml

.PHONY: clean
clean:
	rm -f ~/.vimrc
	rm -f ~/.vim
	rm -f ~/.zshrc
	rm -f ~/.zshenv
	rm -f ~/.gitconfig
	rm -f ~/.git-template
	rm -f ~/.tmux.conf
	rm -f ~/.tmux.conf.linux
	rm -f ~/.ssh/config
	rm -f ~/.config/alacritty/alacritty.yml
