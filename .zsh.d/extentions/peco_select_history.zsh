function peco-select-history() {
    local selected=$(history -n 1 | \
                        tac  | \
                        awk '!a[$0]++' | \
                        peco --query "$LBUFFER")

    if [ -n "$selected" ]; then
        BUFFER="$selected"
        CURSOR=$#BUFFER
        zle reset-prompt
    fi
}

zle -N peco-select-history
bindkey '^R' peco-select-history
