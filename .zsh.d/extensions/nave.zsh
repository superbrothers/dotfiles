# Allow for functions in the prompt.
setopt PROMPT_SUBST

autoload -U colors && colors

nave_node_version() {
    if [ -n "$NODE_PATH" ]; then
        NODE_VERSION=`echo $NODE_PATH | egrep -o '[^a-z/][0-9)\.]+[^a-z/]'`
        echo "%{$fg[yellow]%}[node-$NODE_VERSION]%{$reset_color%}"
    fi
}
