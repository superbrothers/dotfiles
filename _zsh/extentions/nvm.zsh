# Allow for functions in the prompt.
setopt PROMPT_SUBST

autoload -U colors && colors

nvm_node_version() {
    if [ -n "$NVM_BIN" ]; then
        NODE_VERSION=`echo $NVM_BIN | egrep -o 'v[0-9\.]+'`
        echo "%{$fg[green]%}[$NODE_VERSION]%{$reset_color%}"
    fi
}
