#!/bin/bash
# Author: Abe van der Wielen
# Github: https://github.com/the-abe
# Email: abevanderwielen@gmail.com

shopt -s histappend
shopt -s checkwinsize
shopt -s globstar

HISTCONTROL=ignoredups:ignorespace
HISTSIZE=100000
HISTFILESIZE=2000000

# Only set path if it hasn't been set already
if [[ -z "$PATHSET" ]]; then
  PATH=$PATH:$HOME/.local/bin
  PATH=$PATH:$HOME/.cargo/bin
  PATH=$PATH:$HOME/.fzf/bin
  PATH=$PATH:$HOME/.npm-global/bin
  PATH=$PATH:$HOME/.rbenv/bin
  PATH=$PATH:$HOME/.rbenv/shims
  PATH=$PATH:$HOME/go/bin
  PATH=$PATH:/snap/bin
  PATH=$PATH:/usr/local/go/bin
  PATH=$PATH:/usr/share/rvm/bin
  PATH=$PATH:$HOME/.tmux/plugins/tmuxifier/bin
  PATHSET=true
fi

export TERM=xterm-256color
export COLORTERM=truecolor

# Gvm and go
[[ -s "$HOME/.gvm/scripts/gvm" && -z "$GVM_ROOT" ]] && source "$HOME/.gvm/scripts/gvm"

# Rbenv and ruby
if [[ -x /usr/bin/rbenv && -z "$RBENV_SHELL" ]]
then
  eval "$(rbenv init -)"
fi

# Bashrc and tmuxrc alias to edit and source
alias bashrc="\$EDITOR ~/.bashrc; source ~/.bashrc"
alias vimrc="\$EDITOR ~/.config/nvim/init.lua"
alias tmuxrc="\$EDITOR ~/.tmux.conf; tmux source-file ~/.tmux.conf"

# Install dotfiles locally or on a remote machine
alias dotfiles="curl -s https://raw.githubusercontent.com/The-Abe/dotfiles/main/install | bash"
function sshdotfiles() {
  ssh "$1" "curl -s https://raw.githubusercontent.com/The-Abe/dotfiles/main/install | bash"
}

# Sudo last command
alias sl="sudo !!"

# Apt aliases
function ai() {
  sudo apt install "$(al)"
}
function ar() {
  sudo apt remove "$(al)"
}
function al() {
  package=$(apt list 2>/dev/null | fzf)
  echo "${package%/*}"
}
function as() {
  apt search "$1" | less
}

# Sudo edit alias
alias svim="sudo -E nvim -u \$HOME/.config/nvim/init.lua"

# Eza aliase
alias ls="eza --git --group-directories-first"

# FZF and bat
[[ -f ~/.fzf.bash && -z "$FZFSOURCED" ]] && source ~/.fzf.bash
FZFSOURCED=true
export FZF_DEFAULT_OPTS="--preview 'bat --line-range=:200 --theme=gruvbox-light --color=always --style=numbers,changes {} | head -500'"

alias cat='bat --paging=never'
alias bat='bat --theme=gruvbox-light --color=always --style=changes'

# SSH Agent auto add
# If it works, don't touch. I always screw this up when I try to mess with it.
#if [[ -f ~/.ssh/id_rsa.pub ]]
#then
#  if [[ ! -S ~/.ssh/ssh_auth_sock ]]
#  then
#    eval `ssh-agent`
#    ssh-add -l | grep "The agent has no identities" && ssh-add
#    ln -sf $SSH_AUTH_SOCK ~/.ssh/ssh_auth_sock
#  fi
#  export SSH_AUTH_SOCK=~/.ssh/ssh_auth_sock
#fi

# Use nvim if available
if [[ -x $(which nvim) ]]
then
  alias vim="nvim"
  alias vi="nvim"
  EDITOR=$(which nvim)
  export EDITOR
fi

# Color functions

# 256 color foreground
function color() {
  echo -e "\033[38;5;$1m"
}

# 256 color background
function bgcolor() {
  echo -e "\033[48;5;$1m"
}

# 256 color foreground and background
function fbcolor() {
  echo -e "\033[38;5;$1m\033[48;5;$2m"
}

# RGB color foreground
function rgbcolor() {
  echo -e "\033[38;2;$1;$2;$3m"
}

# RGB color background
function rgbbgcolor() {
  echo -e "\033[48;2;$1;$2;$3m"
}

# RGB color foreground and background
function rgbfbcolor() {
  echo -e "$(rgbcolor "$1" "$2" "$3")$(rgbbgcolor "$4" "$5" "$6")"
}

# Bold text
function bold() {
  echo -e "\e[1m"
}

# Reset color
function reset_color() {
  echo -e "\e[m"
}

# Hex color to decimal colors for rgbcolor functions
function hex_to_dec() {
  color=$(echo "$1" | tr '[:lower:]' '[:upper:]')
  red=$(echo "$color" | awk '{print substr($1,1,2)}')
  green=$(echo "$color" | awk '{print substr($1,3,2)}')
  blue=$(echo "$color" | awk '{print substr($1,5,2)}')
  red_dec=$(echo "ibase=16; $red"|bc)
  green_dec=$(echo "ibase=16; $green"|bc)
  blue_dec=$(echo "ibase=16; $blue"|bc)
  echo "$red_dec" "$green_dec" "$blue_dec"
}

function motd() {
  echo

  hostname
  echo
  printf "Uptime:"
  uptime
  echo

  echo "Memory:"
  free -h
  echo

  echo "Disk usage:"
  df -h
  echo
}

function colors() {
  echo
  for I in $(seq 1 1 255)
  do
    if [[ ${I} == 16 ]]
    then
      c=15
    else
      c=0
    fi
    printf "$(color $c)\033[48;5;${I}m %-3i $(reset_color)" "$I"
    if [[ $((I % 8)) == 0 ]]
    then
      echo
    fi
  done
  echo
}

# Make sure the cursor is a block after executing a command
PS0="\e[2 q"

# Set the prompt with PROMPT_COMMAND
if [[ $(hostname) =~ (abes-bak|Abe-Laptop|abe-debian|laptop-abe) ]]; then
  PS1='$(tput cup "$LINES")\n$(if [ $? != 0 ]; then echo "$(color 1)x "; fi)$(color 8)\w$(reset_color)\n> '
else
  PS1='$(tput cup "$LINES")\n$(if [ $? != 0 ]; then echo "$(color 1)x "; fi)$(color 2)\u@\h$(color 8) \w$(reset_color)\n> '
fi

# Load aliases if they exist
[ -f "$HOME/.bash_aliases" ] && . "$HOME/.bash_aliases"

# Generated for envman. Do not edit.
[ -s "$HOME/.config/envman/load.sh" ] && source "$HOME/.config/envman/load.sh"

if [[ -x $(which zoxide) && -z "$ZOXIDELOADED" ]]
then
  eval "$(zoxide init --hook prompt bash)"
  ZOXIDELOADED=true
fi
alias cd="z"
[ -e "$HOME/.cargo/env" ] && . "$HOME/.cargo/env"
[ -e "$HOME/.asdf/asdf.sh" ] && . "$HOME/.asdf/asdf.sh"
[ -e "$HOME/.asdf/completions/asdf.bash" ] && . "$HOME/.asdf/completions/asdf.bash"

complete -C /usr/bin/terraform terraform
[ -e "$HOME/.asdf/installs/rust/1.76.0/env" ] && . "$HOME/.asdf/installs/rust/1.76.0/env"
