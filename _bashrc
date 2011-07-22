### COLORS ###
         RED="\[\033[0;31m\]"
   LIGHT_RED="\[\033[1;31m\]"
      YELLOW="\[\033[1;33m\]"
      ORANGE="\[\033[0;33m\]"
        BLUE="\[\033[0;34m\]"
  LIGHT_BLUE="\[\033[1;34m\]"
       GREEN="\[\033[0;32m\]"
 LIGHT_GREEN="\[\033[1;32m\]"
        CYAN="\[\033[0;36m\]"
  LIGHT_CYAN="\[\033[1;36m\]"
      PURPLE="\[\033[0;35m\]"
LIGHT_PURPLE="\[\033[1;35m\]"
       WHITE="\[\033[1;37m\]"
  LIGHT_GRAY="\[\033[0;37m\]"
       BLACK="\[\033[0;30m\]"
        GRAY="\[\033[1;30m\]"
    NO_COLOR="\[\e[0m\]"

### PROMPT ###
PS1="${PURPLE}\u${WHITE}@${GREEN}`hostname`${WHITE}:${CYAN}\w ${NO_COLOR}\$ "

### PATH ###
#export PATH=/usr/local/bin:/opt/local/bin:~/opt/screen-4.1.0/bin:$PATH
export PATH=$HOME/bin:/usr/local/bin:$PATH
export MANPATH=$HOME/share/man:$MANPATH

### GEM ###
# export GEM_HOME=~/.gem/ruby/1.8

### node.js ###
export NODE_PATH=$HOME/.node/installed/0.3.1/
export PATH=$HOME/.node/installed/0.3.1/bin/:$PATH

### ALIAS ###
alias ls='ls -G'
alias ll='ls -lhFG'
alias la='ls -ahFG'
alias cp='cp -i'
alias rm='rm -i'
alias mv='mv -i'
alias svim='sudo vim'
alias r='rails'
alias g='git'
alias b='bundle'

### rvm ###
if [ -s "$HOME/.rvm/scripts/rvm" ]; then source "$HOME/.rvm/scripts/rvm"; fi

### git-completion ###
source /usr/local/etc/bash_completion.d/git-completion.bash

### FUNCTION ###
cd() { command cd $@; ls; }

# Find a file with the string $1 in the name
function ff() { find . -name '*'$1'*' ; }

# Find a file with the string $1 in the name and exec $2 on it
function fe() { find . -name '*'$1'*' -exec $2 {} \; ; }

function find_grep() {
  find $1 -name $2 | xargs egrep -nC3 $3 | less
}

### GIT ###
GIT_EDITOR="/usr/local/bin/vim -c 'set fenc=utf-8'"

### etc ###
umask 002
export LSCOLORS=gxfxcxdxbxegedabagacad
# 文字コード設定
export __CF_USER_TEXT_ENCODING='0x1F5:0x08000100:14'

### SCREEN ###
#if [ $SHLVL -eq 1 ]; then
#    if which screen > /dev/null 2>&1; then
#        screen -UxR
#    fi
#fi
