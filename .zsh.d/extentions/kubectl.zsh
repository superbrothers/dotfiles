FOUND_KUBECTL=0
if which kubectl >/dev/null 2>&1; then
    FOUND_KUBECTL=1
fi

## Make `kubectl` to respect environment variables such as KUBECTL_CONTEXT
if [ "$FOUND_KUBECTL" -eq 1 ];then
    function kubectl() {
        command kubectl \
            --context="$KUBECTL_CONTEXT" \
            --namespace="$KUBECTL_NAMESPACE" \
            --user="$KUBECTL_USER" \
            --server="$KUBECTL_SERVER" \
            "$@"
    }
fi

## Completion
test "$FOUND_KUBECTL" -eq 1 && source <(kubectl completion zsh)

## PROMPT
zsh_kubectl_prompt="$(ghq root)/github.com/superbrothers/zsh-kubectl-prompt/kubectl.zsh"
[[ ! -f "$zsh_kubectl_prompt" ]] && ghq get superbrothers/zsh-kubectl-prompt
source "$zsh_kubectl_prompt"
