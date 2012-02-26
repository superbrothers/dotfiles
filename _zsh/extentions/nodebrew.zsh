# Allow for functions in the prompt.
setopt PROMPT_SUBST

autoload -U colors && colors

nodebrew_node_version() {
    NODEBREW=`which nodebrew`
    if [ ! -z "$NODEBREW" ]; then
        NODE_VERSION=`$NODEBREW  ls | tail -n 1 | egrep -o '[0-9\.]+'`
        echo "%{$fg[yellow]%}[node-$NODE_VERSION]%{$reset_color%}"
    fi
}
