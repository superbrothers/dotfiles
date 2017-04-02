local ret_status="%(?:%{$fg_bold[green]%}# :%{$fg_bold[red]%}# )"
PROMPT="${ret_status} %{$fg[cyan]%}%c%{$reset_color%} \$(vcs_info_msg) %{$reset_color%}"
RPROMPT='%{$fg[blue]%}($ZSH_KUBECTL_PROMPT)%{$reset_color%}'
setopt transient_rprompt
