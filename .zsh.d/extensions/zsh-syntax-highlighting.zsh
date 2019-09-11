if ! (brew info zsh-syntax-highlighting | grep --quiet "Not installed"); then
    source "$(brew --prefix zsh-syntax-highlighting)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
fi
