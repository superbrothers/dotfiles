PROMPT="%{$fg[magenta]%}${USER} %{$fg[white]%}in %{$fg[green]%}${HOST} %{$fg[white]%}at %{$fg[cyan]%}%~%{$reset_color%}
%# "
RPROMPT='$(rbenv_version)$(nodebrew_node_version)$(vcs_info_msg)[%D %T]'
