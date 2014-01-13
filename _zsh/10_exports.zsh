export EDITOR=vim
export GIT_EDITOR="`which vim` -c 'set fenc=utf-8'"
export __CF_USER_TEXT_ENCODING='0x1F5:0x08000100:14' # 文字コード設定
export PATH=$HOME/Dropbox/root/bin:$HOME/.nodebrew/current/bin:/usr/local/bin:$PATH
export MANPATH=$HOME/share/man:$MANPATH
export RBENV_ROOT=/usr/local/var/rbenv #Used Homebrew
export WORDCHARS='*_[]~;!%^(){}<>'
# coreutils
export PATH="/usr/local/opt/coreutils/libexec/gnubin:$PATH"
export MANPATH="/usr/local/opt/coreutils/libexec/gnuman:$MANPATH"
if which go >/dev/null 2>&1; then
    export GOROOT="/usr/local/Cellar/go/$(go version | grep -o -e '[0-9]\+.[0-9]\+')/libexec"
    export GOPATH="$HOME/.go/$(go version | grep -o -e '[0-9]\+.[0-9]\+')"
fi
