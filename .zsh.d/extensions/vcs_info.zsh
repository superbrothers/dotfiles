# Allow for functions in the prompt.
setopt PROMPT_SUBST

autoload -Uz vcs_info
autoload -Uz add-zsh-hook
autoload -U colors && colors

zstyle ':vcs_info:*' enable git svn hg
zstyle ':vcs_info:*' formats '(%s)-[%b]'
zstyle ':vcs_info:*' actionformats '(%s)-[%b]' '<!%a>'
zstyle ':vcs_info:svn:*' branchformat '%b:r%r'

autoload -Uz is-at-least
if is-at-least 4.3.10; then
    zstyle ':vcs_info:git:*' check-for-changes true
    zstyle ':vcs_info:git:*' stagedstr '+'
    zstyle ':vcs_info:git:*' unstagedstr '-'
    zstyle ':vcs_info:git:*' formats '(%c%u%b)'
    zstyle ':vcs_info:git:*' actionformats '(%c%u%b)' '<!%a>'
fi

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
    if [ "$(git rev-parse --is-inside-work-tree 2>/dev/null)" = "true" ]; then
        head="$(git rev-parse HEAD)"
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
    COUNT=`git stash list 2>/dev/null | wc -l | tr -d ' '`
    if [ "$COUNT" -gt 0 ]; then
        echo "S$COUNT"
    fi
}

vcs_info_msg() {
    echo "%1(v|%F{cyan}%1v%2v%3v%f%F{red}%4v%f|)%{$reset_color%}"
}
