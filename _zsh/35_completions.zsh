# for rbenv
# https://github.com/sstephenson/rbenv/
RBENV_ZSH=$HOME/.rbenv/completions/rbenv.zsh
if [ -r $RBENV_ZSH ]; then
    source $RBENV_ZSH
fi

if [ -x "`which hub 2>/dev/null`" ]; then
    compdef hub=git
fi
