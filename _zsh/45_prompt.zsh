PROMPT="%{$fg[magenta]%}${USER} %{$fg[white]%}in %{$fg[green]%}${HOST} %{$fg[white]%}at %{$fg[cyan]%}%~%{$reset_color%}
%# "
RPROMPT='$(rvm_ruby_version)$(nave_node_version)$(vcs_info_msg)[%D %T]'
