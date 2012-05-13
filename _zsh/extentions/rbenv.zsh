# Allow for functions in the prompt.
setopt PROMPT_SUBST

autoload -U colors && colors

rbenv_version() {
    if which rbenv >/dev/null 2>&1; then
        VERSION=`rbenv version | egrep -o '^[0-9a-z\.-]+'`
        if [ -n "$VERSION" ]; then
            echo "%{$fg[red]%}[ruby-$VERSION]%{$reset_color%}"
        fi
    fi
}
