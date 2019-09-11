## Adding the following settings to .ssh/config
## show remote hostname during ssh
#
# PermitLocalCommand yes
# LocalCommand [[ "$TERM" =~ ^screen ]] && echo -ne "\ek$(echo %h | awk -F "." '{print $1}')\e\\"
#
setopt extended_glob
autoload -Uz add-zsh-hook
function _precmd_screen_title() {
    echo -ne "\ek$(basename $SHELL)\e\\"
}
function _preexec_screen_title() {
    echo -ne "\ek${1/(#b)( *)/}\e\\"
}
add-zsh-hook precmd _precmd_screen_title
add-zsh-hook preexec _preexec_screen_title
