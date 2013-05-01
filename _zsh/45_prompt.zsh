PROMPT="%B%(?.%{$fg[green]%}(^_^%).%{$fg[red]%}(>_<%) $?)%b %{$fg[red]%}${USER} %{$fg[white]%}in %{$fg[green]%}${HOST} %{$fg[white]%}at %{$fg[cyan]%}%~%{$reset_color%}
%# "
RPROMPT='$(rbenv_version)$(nodebrew_node_version)$(vcs_info_msg)[%D %T]'
setopt transient_rprompt
