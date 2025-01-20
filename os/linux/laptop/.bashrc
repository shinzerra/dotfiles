#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'

# prompt
PS1='\[\e[0;91m\][\[\e[0;93m\]\u\[\e[0;92m\]@\[\e[0;94m\]\h \[\e[0;35m\]\w\[\e[0;91m\]]\[\e[0m\]\$ \[\e[0m\]'

# exports
export BROWSER="thorium-browser"
export TERMINAL="alacritty"
export EDITOR="vim"

# aliases
alias nvim='vim'
alias nano='vim'

# path
export PATH="$PATH:/home/gang/.local/bin"
