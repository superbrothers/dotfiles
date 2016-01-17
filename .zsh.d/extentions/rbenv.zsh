# Allow for functions in the prompt.
setopt PROMPT_SUBST

autoload -U colors && colors

if `which rbenv >/dev/null 2>&1` && [ -z "$RBENV_ROOT" ]; then
    export RBENV_ROOT=`rbenv root`
fi

rbenv_version() {
    if [ -x "`which rbenv 2>/dev/null`" ]; then
        VERSION=''
        NOTFOUND=''
        if [ -r .ruby-version ]; then
            VERSION=`cat .ruby-version`
            ls "${RBENV_ROOT}/versions" | egrep "^$VERSION$" >/dev/null 2>&1 || NOTFOUND='{?}'
        else
            VERSION=`cat "${RBENV_ROOT}/version"`
        fi
        echo "%{$fg[red]%}[$VERSION]$NOTFOUND%{$reset_color%}"
    fi
}
