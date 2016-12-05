export EDITOR=vim
export GIT_EDITOR="`which vim` -c 'set fenc=utf-8'"
export __CF_USER_TEXT_ENCODING='0x1F5:0x08000100:14' # 文字コード設定
export PATH=$HOME/bin:$HOME/Dropbox/root/bin:$HOME/.nodebrew/current/bin:/usr/local/bin:$PATH
export MANPATH=$HOME/share/man:$MANPATH
export RBENV_ROOT=/usr/local/var/rbenv #Used Homebrew
export WORDCHARS='*_[]~;!%^(){}<>'
# coreutils
export PATH=$(brew --prefix coreutils)/libexec/gnubin:$PATH
export MANPATH="/usr/local/opt/coreutils/libexec/gnuman:$MANPATH"
# gnu-sed
export PATH="/usr/local/opt/gnu-sed/libexec/gnubin:$PATH"
export MANPATH="/usr/local/opt/gnu-sed/libexec/gnuman:$MANPATH"
# Homebrew
export HOMEBREW_NO_ANALYTICS=1
# https://github.com/motemen/ghq
export GHQ_ROOT="${HOME}/src"
