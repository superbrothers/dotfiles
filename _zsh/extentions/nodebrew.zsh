# Allow for functions in the prompt.
setopt PROMPT_SUBST

autoload -U colors && colors

nodebrew_node_version() {
    if [[ -x `which -p nodebrew` ]]; then
        if [ -z "$NODEBREW_ROOT" ]; then
            NODEBREW_ROOT="$HOME/.nodebrew"
        fi
        NODE_VERSION=`ls -l $NODEBREW_ROOT/current | egrep -o 'v[0-9\.]+'`
        if [ -n "$NODE_VERSION" ]; then
            echo "%{$fg[yellow]%}[node-$NODE_VERSION]%{$reset_color%}"
        fi
    fi
}
