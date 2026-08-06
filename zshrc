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

## homebrew
test -f /home/linuxbrew/.linuxbrew/bin/brew && eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
test -f /opt/homebrew/bin/brew && eval "$(/opt/homebrew/bin/brew shellenv)"

if [[ -n "$HOMEBREW_PREFIX" ]]; then
  export HOMEBREW_NO_ANALYTICS=1
  export HOMEBREW_NO_AUTO_UPDATE=1

  # coreutils
  export PATH="${HOMEBREW_PREFIX}/opt/coreutils/libexec/gnubin:$PATH"
  export MANPATH="${HOMEBREW_PREFIX}/opt/coreutils/libexec/gnuman:$MANPATH"

  # gnu-sed
  export PATH="${HOMEBREW_PREFIX}/opt/gnu-sed/libexec/gnubin:$PATH"
  export MANPATH="${HOMEBREW_PREFIX}/opt/gnu-sed/libexec/gnuman:$MANPATH"

  # gnu-tar
  export PATH="${HOMEBREW_PREFIX}/opt/gnu-tar/libexec/gnubin:$PATH"
  export MANPATH="${HOMEBREW_PREFIX}/opt/gnu-tar/libexec/gnuman:$PATH"

  # z: https://github.com/rupa/z
  source "${HOMEBREW_PREFIX}/etc/profile.d/z.sh"
fi



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
if which npm >/dev/null 2>&1; then
  export PATH="$(npm prefix -g)/bin:$PATH"
fi

export TZ=Asia/Tokyo

# homebrew
test -f /home/linuxbrew/.linuxbrew/bin/brew && eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
test -f /opt/homebrew/bin/brew && eval "$(/opt/homebrew/bin/brew shellenv)"

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
lazyload asdf -- 'source <(asdf completion zsh)'

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

# List every worktree of the current repo, paired with its resumable Claude
# Code session if one exists (~/.claude/projects/<encoded-worktree-path>/).
# _col_width / _fzf_pick / _claude_status_* are defined in zshenv, alongside
# tmuxjump, so they're shared between this widget and the non-interactive
# `zsh -c tmuxjump` tmux.conf invokes.
function fzf-select-worktree() {
  emulate -L zsh
  setopt no_aliases

  local REPLY
  if ! _claude_missing_commands git fzf jq; then
    zle -M "fzf-select-worktree: command not found: $REPLY"
    return 1
  fi

  local -a lines
  lines=("${(@f)$(command git worktree list --porcelain 2>/dev/null)}")
  if (( ${#lines} == 0 )); then
    zle -M "Not a git repository"
    return
  fi

  _claude_status_invalidate

  local namecap=28 branchcap=45

  # pass 1: collect one record per worktree (name, branch, path, resumable
  # session id + title, all already truncated to their display caps)
  local -a wt_name wt_branch wt_path wt_sid wt_title
  local line cur="" branch="(detached)" enc f latest sid title name
  for line in $lines "worktree"; do
    if [[ $line == worktree\ * || $line == worktree ]]; then
      if [[ -n "$cur" ]]; then
        name=${cur:t}
        (( ${#name} > namecap )) && name="${name[1,namecap-1]}…"
        (( ${#branch} > branchcap )) && branch="${branch[1,branchcap-1]}…"

        enc=${cur//[^a-zA-Z0-9]/-}
        latest=""
        for f in $HOME/.claude/projects/$enc/*.jsonl(N.om); do
          latest=$f
          break
        done
        sid="" title=""
        if [[ -n "$latest" ]]; then
          sid=${latest:t:r}
          # Claude Code's own auto-generated / user-set session title (the
          # same text shown in its `/resume` picker)
          title=$(jq -r 'select(.type=="ai-title" or .type=="agent-name") | (.aiTitle // .agentName)' "$latest" 2>/dev/null | tail -1)
          [[ -z "$title" ]] && title=$sid
        fi

        wt_name+=("$name")
        wt_branch+=("$branch")
        wt_path+=("$cur")
        wt_sid+=("$sid")
        wt_title+=("$title")
      fi
      cur=${line#worktree }
      [[ "$cur" == "worktree" ]] && cur=""
      branch="(detached)"
    elif [[ $line == branch\ * ]]; then
      branch=${${line#branch }#refs/heads/}
    fi
  done

  # column widths: widest name / branch actually present (already capped
  # above, so a very long branch name can't blow out the whole table)
  local namew=$(_col_width "${wt_name[@]}") branchw=$(_col_width "${wt_branch[@]}")

  # pass 2: render, one resume row (if any) + one new-session row per worktree
  local -a rows
  local i label marker new_marker
  new_marker=$'\e[2m+ new session\e[0m'
  for (( i = 1; i <= ${#wt_name}; i++ )); do
    if [[ -n "${wt_sid[$i]}" ]]; then
      # live status (waiting/busy/idle) takes priority over the plain
      # "resumable" dot, since it tells you whether it needs your input now
      _claude_status_marker "${wt_path[$i]}"
      marker=$REPLY
      [[ -z "$marker" ]] && marker=$'\e[32m●\e[0m'
      label=$(printf "%-${namew}s  %-${branchw}s  │ %s %s" "${wt_name[$i]}" "${wt_branch[$i]}" "$marker" "${wt_title[$i]}")
      rows+=("$label	${wt_path[$i]}	${wt_sid[$i]}")
    fi
    label=$(printf "%-${namew}s  %-${branchw}s  │ %s" "${wt_name[$i]}" "${wt_branch[$i]}" "$new_marker")
    rows+=("$label	${wt_path[$i]}	-")
  done

  local selected
  selected=$(_fzf_pick "${rows[@]}")
  if [[ -n "$selected" ]]; then
    local cdpath=${${selected#*$'\t'}%%$'\t'*}
    sid=${selected##*$'\t'}
    if [[ "$sid" == "-" ]]; then
      BUFFER="cd ${(q)cdpath} && claude"
    else
      BUFFER="cd ${(q)cdpath} && claude --resume $sid"
    fi
    zle accept-line
  fi
  zle clear-screen
}
zle -N fzf-select-worktree
bindkey '^G' fzf-select-worktree

## MISC SETTINGS ###################################

# auto ls
function auto_ls() { ls }
add-zsh-hook chpwd auto_ls

# Rust
test -f "$HOME/.cargo/env" && source "$HOME/.cargo/env"

# Rancher Desktop
test -d "$HOME/.rd/bin" && export PATH="$HOME/.rd/bin:$PATH"

# asdf
export PATH="${ASDF_DATA_DIR:-$HOME/.asdf}/shims:$PATH"

# Senstive functions which are not pushed to Github
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local

# automatically remove duplicates
typeset -U path
# vim: set ai ts=2 sw=2 et sts=2 ft=zsh :
