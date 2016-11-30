local ret_status="%(?:%{$fg_bold[green]%}# :%{$fg_bold[red]%}# )"
PROMPT="${ret_status} %{$fg[cyan]%}%c%{$reset_color%} \$(vcs_info_msg) %{$reset_color%}"
RPROMPT='%{$fg[blue]%}[$(kubernetes_prompt_info)]%{$reset_color%}'
setopt transient_rprompt
