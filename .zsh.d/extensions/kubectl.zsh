if which kubectl >/dev/null 2>&1; then
  alias k='kubectl'

  ## Completion
  source <(kubectl completion zsh)
  complete -o default -F __start_kubectl k

  ## PROMPT
  zsh_kubectl_prompt="$(brew --prefix)/etc/zsh-kubectl-prompt/kubectl.zsh"
  if [[ -f "$zsh_kubectl_prompt" ]]; then
    source "$zsh_kubectl_prompt"
  fi
fi

# Completion for Kind
if which kind >/dev/null 2>&1; then
  source <(kind completion zsh)
fi

## https://github.com/GoogleContainerTools/krew
export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"
