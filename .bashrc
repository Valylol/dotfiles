#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'
PS1='[\u@\h \W]\$ '


# ~/.bashrc
export MPD_HOST=~/.config/mpd/socket
eval "$(starship init bash)"
export PATH=$PATH:/home/valentijn/.spicetify
alias ff="fastfetch"
alias mountnas="source ~/.config/hypr/scripts/mount_nas.sh"
# Created by `pipx` on 2026-01-18 03:43:12
export PATH="$PATH:/home/valentijn/.local/bin"
