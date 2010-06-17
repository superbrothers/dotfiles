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

### ALIAS ###
alias ls='ls -G'
alias ll='ls -lhFG'
alias la='ls -ahFG'
alias cp='cp -i'
alias rm='rm -i'
alias mv='mv -i'
alias vi='vim'
alias svim='sudo vim'

### FUNCTION ###
cd() { command cd $@; ls; }

# Find a file with the string $1 in the name
function ff() { find . -name '*'$1'*' ; }

# Find a file with the string $1 in the name and exec $2 on it
function fe() { find . -name '*'$1'*' -exec $2 {} \; ; }

function find_grep() {
  find $1 -name $2 | xargs egrep -nC3 $3 | less
}

### SCREEN ###
if [ $SHLVL -eq 1 -a -e "`which screen`" ]; then
  screen -UxR
fi

### GIT ###
GIT_EDITOR="'vim' -c 'set fenc=utf-8'"

### PATH ###
PATH=/opt/local/bin:$PATH


### etc ###
umask 002
export LSCOLORS=Gxfxcxdxbxegedabagacad
