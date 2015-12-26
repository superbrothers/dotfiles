# http://qiita.com/ysk_1031/items/8cde9ce8b4d0870a129d

function peco-src () {
    local selected_dir=$(ghq list | peco --query "$LBUFFER")
    if [ -n "$selected_dir" ]; then
        BUFFER="cd $(ghq root)/${selected_dir}"
        zle accept-line
    fi
    zle clear-screen
}

zle -N peco-src
bindkey '^]' peco-src
