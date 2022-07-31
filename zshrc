if [[ ! -d "$HOME/.zinit" ]]; then
  mkdir -p "$HOME/.zinit"
  git clone https://github.com/zdharma-continuum/zinit.git "$HOME/.zinit/bin"
fi

source "$HOME/.zinit/bin/zinit.zsh"

zinit wait lucid for \
  atinit"ZINIT[COMPINIT_OPTS]=-C; zicompinit; zicdreplay" \
    zdharma-continuum/fast-syntax-highlighting \
  blockf \
    zsh-users/zsh-completions \
  atload"!_zsh_autosuggest_start" \
    zsh-users/zsh-autosuggestions

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
export ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20

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
alias watch='watch '
alias g='hub'
which hub >/dev/null 2>&1 && alias git=hub
which nvim >/dev/null 2>&1 && alias vim=nvim

if [[ "$(uname)" == "Linux" ]]; then
  # Use clipper for sharing clipboard from remote to local
  # https://github.com/wincent/clipper
  if [[ -S "${HOME}/.clipper.sock" ]]; then
    alias pbcopy='socat - UNIX-CLIENT:$HOME/.clipper.sock'
  else
    alias pbcopy='xsel --clipboard --input'
  fi

  alias pbpaste='xsel --clipboard --output'
  alias open='xdg-open'
fi

alias k='kubectl'
function kd() { set -x; kubectl run -it --rm debug-$(date +%s) --image=ghcr.io/superbrothers/debug "$@" -- /bin/bash }

### EXPORT ####################################

export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
if which nvim >/dev/null; then
  export EDITOR=nvim
else
  export EDITOR=vim
fi
export GPG_TTY="$(tty)"

export PATH="${HOME}/bin:$PATH"
# https://github.com/GoogleContainerTools/krew
export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"
# NPM
if which npm 2>&1 >/dev/null; then
  export PATH="$(npm bin -g):$PATH"
fi

export TZ=Asia/Tokyo

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

  # asdf-vm. zsh completions will be installed
  source "${HOMEBREW_PREFIX}/opt/asdf/libexec/asdf.sh"

  # z: https://github.com/rupa/z
  source "${HOMEBREW_PREFIX}/etc/profile.d/z.sh"
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
lazyload flux -- 'source <(flux completion zsh) && compdef _flux flux'

## KEY BINDINGS ######################################

bindkey -e

function show-buffer-stack() {
  POSTDISPLAY="
stack: $LBUFFER"
  zle push-line-or-edit
}
zle -N show-buffer-stack
setopt noflowcontrol
bindkey '^q' show-buffer-stack

function fzf-select-history() {
  local selected="$(history -n 1 | tac  | awk '!a[$0]++' | fzf --exact --reverse --no-sort --query "$LBUFFER")"
  if [[ -n "$selected" ]]; then
    BUFFER="$selected"
    CURSOR=$#BUFFER
    zle reset-prompt
  fi
}
zle -N fzf-select-history
bindkey '^R' fzf-select-history

function fzf-select-src () {
  local selected="$(ghq list | fzf --exact --reverse --preview "tree -C $(ghq root)/{} | head -200")"
  if [[ -n "$selected" ]]; then
    cd "$(ghq root)/${selected}"
    zle accept-line
  fi
  zle clear-screen
}
zle -N fzf-select-src
bindkey '^[' fzf-select-src

function fzf-select-directory() {
  local selected="$(z | cut -c 12- | tac | fzf --exact --reverse --no-sort --preview 'tree -C {} | head -200')"
  if [[ -n "$selected" ]]; then
    cd "$selected"
    zle accept-line
  fi
  zle clear-screen
}
zle -N fzf-select-directory
bindkey '^]' fzf-select-directory

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
# vim: set ai ts=2 sw=2 et sts=2 ft=zsh :
