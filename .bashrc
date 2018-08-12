# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
  . /etc/bashrc
fi

# User specific aliases and functions go here (override system defaults)

if [ -f /etc/bash_completion ]; then
  . /etc/bash_completion
fi

# bash'em
alias ls='ls --color'
alias ll='ls --color -lh'
alias la='ls --color -a'
alias resourcebash='source ~/.bashrc'
export HISTIGNORE="&:ls:bg:fg:exit"
HISTSIZE=20000
HISTFILESIZE=20000
set -o vi
export PS1="\[\033[0;36m\][\u@\h(\t): \[\033[0;33m\]\w ]\$\[\033[0m\] "
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias :q='exit'

export GREP_COLOR='0;32'
export GREP_COLORS='0;32'
alias grep='grep --color -I'
alias less='less -R'

# Don't delete whole word with Ctrl-W
stty werase undef
bind '"\C-w": backward-kill-word'

PATH=$PATH:/home/aneeshnaman/Programming/Anantak/nodejs/node-v8.11.3-linux-x64/bin

alias wfh='ssh aneeshnaman-linux.sea.corp.google.com'
