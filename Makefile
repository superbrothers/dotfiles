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
	test -f ~/.vim || ln -s $(PWD)/vim ~/.vim
	test -f ~/.zshrc || ln -s $(PWD)/zshrc ~/.zshrc
	test -f ~/.gitconfig || ln -s $(PWD)/gitconfig ~/.gitconfig
	test -f ~/.git-template || ln -s $(PWD)/git-template ~/.git-template
	test -f ~/.tmux.conf || ln -s $(PWD)/tmux.conf ~/.tmux.conf
	mkdir -p ~/.ssh && chmod 700 ~/.ssh
	test -f ~/.ssh/config || ln -s $(PWD)/sshconfig ~/.ssh/config
	mkdir -p ~/.config/alacritty
	test -f ~/.config/alacritty/alacritty.yml || ln -s $(PWD)/alacritty.yml ~/.config/alacritty/alacritty.yml

.PHONY: clean
clean:
	rm -f ~/.vimrc
	rm -f ~/.vim
	rm -f ~/.zshrc
	rm -f ~/.gitconfig
	rm -f ~/.git-template
	rm -f ~/.tmux.conf
	rm -f ~/.ssh/config
	rm -f ~/.config/alacritty/alacritty.yml
