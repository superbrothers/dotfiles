if [[ ! -d "$HOME/.zinit" ]]; then
  mkdir -p "$HOME/.zinit"
  git clone https://github.com/zdharma/zinit.git "$HOME/.zinit/bin"
fi

source "$HOME/.zinit/bin/zinit.zsh"

zinit wait lucid light-mode for \
  atinit"zicompinit; zicdreplay" \
    zdharma/fast-syntax-highlighting \
  atload"_zsh_autosuggest_start" \
    zsh-users/zsh-autosuggestions \
  blockf atpull'zinit creinstall -q .' \
    zsh-users/zsh-completions \

zinit light-mode for \
  compile'(pure|async).zsh' pick'async.zsh' src'pure.zsh' \
    sindresorhus/pure \
  pick"zsh-lazyload.zsh" \
    qoomon/zsh-lazyload \
  pick"kubectl.zsh" \
    superbrothers/zsh-kubectl-prompt \

zinit lucid has'docker' for \
  as'completion' is-snippet \
    https://github.com/docker/cli/blob/master/contrib/completion/zsh/_docker \

## PLUGIN #############################################

# sindresorhus/pure
zstyle :prompt:pure:git:stash show yes

# zsh-autosuggestions
export ZSH_AUTOSUGGEST_STRATEGY=("history")
export ZSH_AUTOSUGGEST_MANUAL_REBIND=1
export ZSH_AUTOSUGGEST_HISTORY_IGNORE="cd *"
export ZSH_AUTOSUGGEST_USE_ASYNC=1

# zsh-kubectl-prompt
# Avoid invoking kubectl command in a script, which will cause lazyload to stop working
test -f "$HOME/bin/kz" >/dev/null || ln "$(which kubectl)" "$HOME/bin/kz"
zstyle :zsh-kubectl-prompt: binary kz

### PROMPT ############################################

autoload -U colors && colors
setopt transient_rprompt

function _number_jobs_prompt_precmd {
  NUMBER_JOBS=""
  if [[ $(jobs | wc -l) > 0 ]]; then
    NUMBER_JOBS="%{$fg[magenta]%}[%j]%{$reset_color%}"
  fi
}
add-zsh-hook precmd _number_jobs_prompt_precmd

RPROMPT=""
# number jobs
RPROMPT+='$NUMBER_JOBS '
# zsh-kubectl-prompt
RPROMPT+='%{$fg[cyan]%}($ZSH_KUBECTL_PROMPT)%{$reset_color%}'
 
## ALIAS ##############################################

alias ..='cd ..'
alias ls='ls --color'
alias ll='ls -lhF --color'
alias la='ls -ahF --color'
alias cp='cp -i'
alias rm='rm -i'
alias mv='mv -i'
alias grep='grep --color=auto'
alias vi='vim'
alias g='git'
which hub >/dev/null 2>&1 && alias git=hub

if [[ "$(uname)" == "Linux" ]]; then
  alias pbcopy='xsel --clipboard --input'
  alias pbpaste='xsel --clipboard --output'
  alias open='xdg-open'
fi

alias k='kubectl'
function kd() { set -x; kubectl run -it --rm debug-$(date +%s) --image=ghcr.io/superbrothers/debug "$@" -- /bin/bash }

### EXPORT ####################################

export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export EDITOR=vim

export PATH="${HOME}/bin:$PATH"
# https://github.com/GoogleContainerTools/krew
export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"

# homebrew
test -f /home/linuxbrew/.linuxbrew/bin/brew && eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)
test -f /usr/local/bin/brew && eval $(/usr/local/bin/brew shellenv)

if [[ -n "$HOMEBREW_PREFIX" ]]; then
  export HOMEBREW_NO_ANALYTICS=1

  # coreutils
  export PATH="${HOMEBREW_PREFIX}/opt/coreutils/libexec/gnubin:$PATH"
  export MANPATH="${HOMEBREW_PREFIX}/opt/coreutils/libexec/gnuman:$MANPATH"

  # gnu-sed
  export PATH="${HOMEBREW_PREFIX}/opt/gnu-sed/libexec/gnubin:$PATH"
  export MANPATH="${HOMEBREW_PREFIX}/opt/gnu-sed/libexec/gnuman:$MANPATH"

  # gnu-tar
  export PATH="${HOMEBREW_PREFIX}/opt/gnu-tar/libexec/gnubin:$PATH"
  export MANPATH="${HOMEBREW_PREFIX}/opt/gnu-tar/libexec/gnuman:$PATH"

  # asdf-vm
  source "${HOMEBREW_PREFIX}/opt/asdf/asdf.sh"
  lazyload asdf -- ". ${HOMEBREW_PREFIX}/opt/asdf/etc/bash_completion.d/asdf.bash"
fi


if which go >/dev/null 2>&1; then
  export GOPATH="$HOME"
fi

# https://github.com/motemen/ghq
export GHQ_ROOT="${HOME}/src"

## HISTORY ############################################

# Command history configuration
HISTFILE="$HOME/.zsh_history"
HISTSIZE=1000000
SAVEHIST=1000000

setopt append_history
setopt extended_history
setopt hist_expire_dups_first
# ignore duplication command history list
setopt hist_ignore_dups 
setopt hist_ignore_space
setopt hist_verify
setopt inc_append_history

# # https://github.com/zsh-users/zsh/blob/master/Functions/Zle/history-search-end
autoload history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end

setopt auto_pushd
setopt pushd_ignore_dups

## COMPLETIONS ########################################

autoload bashcompinit && bashcompinit
zmodload -i zsh/complist

WORDCHARS=''
unsetopt menu_complete
unsetopt flowcontrol
setopt auto_menu
setopt complete_in_word
setopt always_to_end
setopt list_packed
setopt nolistbeep
setopt list_packed

zstyle ':completion:*:default' menu select=1
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*' list-colors ''
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#) ([0-9a-z-]#)*=01;34=0=01'

lazyload kubectl -- 'source <(kubectl completion zsh)'
lazyload stern -- 'source <(stern --completion=zsh)'
lazyload clusterctl -- 'source <(clusterctl completion zsh 2>/dev/null)'
lazyload kind -- 'source <(kind completion zsh; echo compdef _kind kind)'
lazyload helm -- 'source <(helm completion zsh)'

## KEY BINDINGS ######################################

bindkey -e
bindkey "^p" history-beginning-search-backward-end
bindkey "^n" history-beginning-search-forward-end

function show_buffer_stack() {
  POSTDISPLAY="
stack: $LBUFFER"
  zle push-line-or-edit
}
zle -N show_buffer_stack
setopt noflowcontrol
bindkey '^q' show_buffer_stack

function peco-select-history() {
  local selected=$(history -n 1 | \
                      tac  | \
                      awk '!a[$0]++' | \
                      peco --query "$LBUFFER")

  if [[ -n "$selected" ]]; then
    BUFFER="$selected"
    CURSOR=$#BUFFER
    zle reset-prompt
  fi
}
zle -N peco-select-history
bindkey '^R' peco-select-history

# http://qiita.com/ysk_1031/items/8cde9ce8b4d0870a129d
function peco-src () {
  local selected_dir=$(ghq list | peco --query "$LBUFFER")
  if [ -n "$selected_dir" ]; then
    BUFFER="cd $(ghq root)/${selected_dir}"
    zle accept-line
  fi
  zle clear-screen
}

zle -N peco-src
bindkey '^]' peco-src

## MISC SETTINGS ###################################

# auto ls
function auto_ls() { ls }
add-zsh-hook chpwd auto_ls

# Rust
source "$HOME/.cargo/env"

# Senstive functions which are not pushed to Github
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local

# automatically remove duplicates
typeset -U path
# vim: set ft=zsh :
