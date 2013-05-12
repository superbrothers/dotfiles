autoload -Uz add-zsh-hook
function _precmd_screen_title() {
    echo -ne "\ek$(hostname|awk 'BEGIN{FS="."}{print $1}')\e\\"
}
function _preexec_screen_title() {
    mycmd=(${(s: :)${1}})
    echo -ne "\ek$(hostname|awk 'BEGIN{FS="."}{print $1}'):$mycmd[1]\e\\"
}
add-zsh-hook precmd _precmd_screen_title
add-zsh-hook preexec _preexec_screen_title
