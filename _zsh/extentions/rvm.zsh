# Allow for functions in the prompt.
setopt PROMPT_SUBST

autoload -U colors && colors

rvm_ruby_version() {
    echo "%{$fg[red]%}[$rvm_ruby_string]%{$reset_color%}"
}
