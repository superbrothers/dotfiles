autoload -Uz add-zsh-hook
function auto_ls() {
    command ls --color
}
add-zsh-hook chpwd auto_ls
