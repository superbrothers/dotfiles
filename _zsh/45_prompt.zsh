PROMPT="%B%(?.%{$fg[green]%}(^_^%).%{$fg[red]%}(>_<%))%b %{$fg[red]%}${USER} %{$fg[white]%}in %{$fg[green]%}${HOST} %{$fg[white]%}at %{$fg[cyan]%}%~%{$reset_color%}
%# "
RPROMPT='$(vcs_info_msg)$(rbenv_version)$(nvm_node_version)[%D %T]'
setopt transient_rprompt
