if which kubectl >/dev/null 2>&1; then
    ## Completion
    source <(kubectl completion zsh)

    ## PROMPT
    zsh_kubectl_prompt="$(ghq root)/github.com/superbrothers/zsh-kubectl-prompt/kubectl.zsh"
    [[ ! -f "$zsh_kubectl_prompt" ]] && ghq get superbrothers/zsh-kubectl-prompt
    source "$zsh_kubectl_prompt"
fi
