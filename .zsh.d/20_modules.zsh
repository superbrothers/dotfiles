autoload -Uz compinit && compinit -u
# autoload predict-on && predict-on
autoload -U colors && colors
# history
autoload history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
