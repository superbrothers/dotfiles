autoload -Uz add-zsh-hook
function auto_ls() {
    command ls -G
}
add-zsh-hook chpwd auto_ls
