# brew install z
if [[ -x "`which brew 2>/dev/null`" ]]; then
    . `brew --prefix`/etc/profile.d/z.sh
    autoload -Uz add-zsh-hook
    function _Z_precmd () {
        z --add "$(pwd -P)"
    }
    add-zsh-hook precmd _Z_precmd
fi
