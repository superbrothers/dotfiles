if which kubectl >/dev/null 2>&1; then
  ## Completion
  source <(kubectl completion zsh)

  ## PROMPT
  zsh_kubectl_prompt="$(brew --prefix)/etc/zsh-kubectl-prompt/kubectl.zsh"
  if [[ -f "$zsh_kubectl_prompt" ]]; then
    source "$zsh_kubectl_prompt"
  fi
fi
