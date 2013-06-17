# Allow for functions in the prompt.
setopt PROMPT_SUBST

autoload -U colors && colors

rbenv_version() {
    if [ -n "$RBENV_ROOT" ]; then
        if [ -r .ruby-version ]; then
            VERSION=`cat .ruby-version`
        else
            VERSION=`cat "${RBENV_ROOT}/version"`
        fi
        echo "%{$fg[red]%}[$VERSION]%{$reset_color%}"
    fi
}
