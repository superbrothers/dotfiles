# ===================
#   ALIAS
# ===================
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

if [ "$(uname)" = "Linux" ]; then
    alias pbcopy='xsel --clipboard --input'
    alias pbpaste='xsel --clipboard --output'
    alias open='xdg-open'
fi

alias k='kubectl'
function kd() {
  set -x
  kubectl run -it --rm debug --image=ghcr.io/superbrothers/debug "${@[@]}" -- /bin/bash
}

# ===================
#    EXPORT
# ===================
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export EDITOR=vim

export PATH="${HOME}/bin:$PATH"
# https://github.com/GoogleContainerTools/krew
export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"

# homebrew
if [[ -f /usr/local/bin/brew ]]; then
  export HOMEBREW_NO_ANALYTICS=1

  export PATH="/usr/local/bin:$PATH"

  # coreutils
  export PATH="/usr/local/opt/coreutils/libexec/gnubin:$PATH"
  export MANPATH="/usr/local/opt/coreutils/libexec/gnuman:$MANPATH"

  # gnu-sed
  export PATH="/usr/local/opt/gnu-sed/libexec/gnubin:$PATH"
  export MANPATH="/usr/local/opt/gnu-sed/libexec/gnuman:$MANPATH"
fi


if which go >/dev/null 2>&1; then
  export GOPATH="$HOME"
fi

# https://github.com/motemen/ghq
export GHQ_ROOT="${HOME}/src"

# ===================
#    HISTORY
# ===================
## Command history configuration
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
# share command history data
setopt share_history

# https://github.com/zsh-users/zsh/blob/master/Functions/Zle/history-search-end
autoload history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end

setopt auto_pushd
setopt pushd_ignore_dups

# ===================
#    PROMPT
# ===================
autoload -U colors && colors
autoload -Uz add-zsh-hook
setopt promptsubst

# github.com/superbrothers/zsh-kubectl-prompt
source /usr/local/etc/zsh-kubectl-prompt/kubectl.zsh

autoload -Uz vcs_info
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:*' formats '(%s)-[%b]'
zstyle ':vcs_info:*' actionformats '(%s)-[%b]' '<!%a>'

zstyle ':vcs_info:git:*' check-for-changes true
zstyle ':vcs_info:git:*' stagedstr '+'
zstyle ':vcs_info:git:*' unstagedstr '-'
zstyle ':vcs_info:git:*' formats '(%c%u%b)'
zstyle ':vcs_info:git:*' actionformats '(%c%u%b)' '<!%a>'

function _update_vcs_info_msg() {
  psvar=()
  LANG=en_US.UTF-8 vcs_info
  psvar[2]=$(_git_not_pushed)
  psvar[3]=$(_git_stash_count)
  [[ -n "$vcs_info_msg_0_" ]] && psvar[1]="$vcs_info_msg_0_"
  [[ -n "$vcs_info_msg_1_" ]] && psvar[4]="$vcs_info_msg_1_"
}
add-zsh-hook precmd _update_vcs_info_msg

function _git_not_pushed() {
  if [[ "$(git rev-parse --is-inside-work-tree 2>/dev/null)" == "true" ]]; then
    local head="$(git rev-parse HEAD)"
    for x in $(git rev-parse --remotes); do
      if [ "$head" = "$x" ]; then
        return 0
      fi
    done
    echo "{?}"
  fi
  return 0
}

function _git_stash_count() {
  local count=`git stash list 2>/dev/null | wc -l | tr -d ' '`
  if [ "$count" -gt 0 ]; then
    echo "S$count"
  fi
}

function vcs_info_msg() {
    echo "%1(v|%F{cyan}%1v%2v%3v%f%F{red}%4v%f|)%{$reset_color%}"
}

local ret_status='%(?:%{$fg_bold[green]%}# :%{$fg_bold[red]%}# )'
PROMPT="${ret_status} %{$fg[cyan]%}%c%{$reset_color%} $(vcs_info_msg) %{$reset_color%}"
RPROMPT='%{$fg[blue]%}($ZSH_KUBECTL_PROMPT)%{$reset_color%}'
setopt transient_rprompt

# ===================
#    AUTOCOMPLETION
# ===================
autoload -Uz compinit && compinit -u
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

which hub >/dev/null 2>&1 && compdef hub=git

if which kubectl >/dev/null 2>&1; then
  source <(kubectl completion zsh)
  complete -o default -F __start_kubectl k
fi

which kind >/dev/null 2>&1 && kind completion zsh > "${fpath[1]}/_kind"
which stern >/dev/null 2>&1 && source <(stern --completion=zsh)
which clusterctl >/dev/null 2>&1 && source <(clusterctl completion zsh)

# asdf-vm
if which asdf >/dev/null 2>&1 && which brew >/dev/null 2>&1; then
  . /usr/local/opt/asdf/asdf.sh
  . /usr/local/opt/asdf/etc/bash_completion.d/asdf.bash
elif [[ -n "${ASDF_DATA_DIR}" ]]; then
  . "${ASDF_DATA_DIR}/completions/asdf.bash"
fi


# brew info zsh-completions
fpath=(/usr/local/share/zsh-completions $fpath)

# ===================
#    KEY BINDINGS
# ===================
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

# ===================
#    PLUGINS
# ===================
source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# ===================
#    MISC SETTINGS
# ===================
# auto ls
function auto_ls() {
  command ls
}
add-zsh-hook chpwd auto_ls

# Senstive functions which are not pushed to Github
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local

# automatically remove duplicates
typeset -U path
# vim: set ft=zsh :
