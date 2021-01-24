git clone git@github.com/superbrothers/dotfiles.git
# Install and upgrade all dependencies from the Brewfile.
make bundle
ln -s dotfiles/.vimrc ~/.vimrc
