alias vim=nvim
alias ontw='ssh ontw'
alias suod='sudo'
alias mkcd='mkdir_cd'
alias mkvim='mkdir_vim'
alias mvln='mv_ln'

mkdir_cd() {
  mkdir -p "$1"
  cd "$1"
}

mkdir_vim() {
  mkdir -p "$1"
  nvim "$1"
}

mv_ln() {
  src=$(readlink "$1")
  mv "$src" "$2"
  dest=$(readlink "$2")
  ln -s "$dest" "$src"
}

indentsort() {
  awk '!/^ +/ {S=$0; print "%%" $0; next}
  {$0="%%" S "%% " $0} 1' | sort | sed 's/^%%.*%% //' | sed 's/^%%//'
}

alias trash='mv -t ~/.Trash'

cache() {
  command="$@"
  env_vars=$(env | sort)
  cache_string=$(echo "$command|$env_vars" | md5sum | cut -d\  -f1)
  if [ ! -f "/tmp/$cache_string" ]; then
    eval "$command" >"/tmp/$cache_string"
  fi
  less "/tmp/$cache_string"
}

backup() {
  cp -r "$1" "$1"~.$(date +%Y%m%d%H%M%S)
}

cleanbackups() {
  find . -maxdepth 1 -name '*~.*' -print -delete
}

onchange() {
  fswatch -m poll_monitor --event Updated $1 | xargs -I{} -n1 $2
}

idserver() {
  ssh $1 "{ hostname -I && hostname -A ;} | tr -d '\n'"
}

# Aliases using pnemonics

alias g='git'
alias gs='git status'
alias ga='git add'
alias gaa='git add --all'
alias gc='git commit'
alias gcm='git commit -m'
alias gp='git push'
alias gpl='git pull'
alias gco='git checkout'
alias gb='git branch'
alias gcl='git clone'
alias gl='git log'
alias gd='git diff'

alias v='nvim'

alias d='docker'
alias dc='docker-compose'
alias dcb='docker-compose build'
alias dcr='docker-compose run'
alias dce='docker-compose exec'
alias dcd='docker-compose down'
alias dcl='docker-compose logs'
alias dcu='docker-compose up'
alias dcp='docker-compose ps'
alias dci='docker-compose images'
alias dcrun='docker-compose run --rm'
alias dn='docker network'
alias di='docker image'
alias dr='docker run'
alias dps='docker ps'

alias h='hg'
alias hs='hg status'
alias ha='hg add'
alias hc='hg commit'
alias hp='hg push'
alias hpl='hg pull'
alias hb='hg branch'
alias hcl='hg clone'
alias hl='hg log'
alias hd='hg diff'

alias b='bundle'
alias be='bundle exec'
alias bi='bundle install'
alias bu='bundle update'
alias bs='bundle show'
alias br='bundle exec rails'
alias brs='bundle exec rails server -b 0.0.0.0'
alias brc='bundle exec rails console'
alias brd='bundle exec rails destroy'
alias brr='bundle exec rails routes'

alias m='make'
alias mc='make clean'
alias mci='make clean install'
alias mi='make install'

alias c='cargo'
alias cb='cargo build'
alias cr='cargo run'
alias ct='cargo test'
alias cc='cargo check'
alias ccl='cargo clippy'

alias f='\fd'
alias ff='\fd -t f'
alias fd='\fd -t d'

alias t='tmux'
alias ta='tmux attach'
alias tl='tmux ls'
alias tk='tmux kill-session'
alias tn='tmux new-session -s'
alias ts='tmux switch -t'

alias i3r='i3-msg reload'

alias gr='rg'
alias grs='rg --stats'
alias grf='rg --files'
alias grl='rg --files-without-match'
alias grm='rg --files-with-matches'
alias gra='rg --all-files'
alias grh='rg --hidden'
alias grv='rg --invert-match'

alias l='ls -l'
alias la='ls -la'

alias ap='ansible-playbook'
alias apb='ansible-playbook --become'
alias apc='ansible-playbook --check'
alias apv='ansible-playbook -vvv'
alias apbc='ansible-playbook --become --check'
alias apcb='ansible-playbook --become --check'
alias apbv='ansible-playbook --become -vvv'
alias apvb='ansible-playbook --become -vvv'
alias apcv='ansible-playbook --check -vvv'
alias apvc='ansible-playbook --check -vvv'
alias apbcv='ansible-playbook --become --check -vvv'
alias apbvc='ansible-playbook --become --check -vvv'
alias apvbc='ansible-playbook --become --check -vvv'
alias apvcb='ansible-playbook --become --check -vvv'
alias apcvb='ansible-playbook --become --check -vvv'
alias apcbv='ansible-playbook --become --check -vvv'

alias k='kill'
alias ka='killall'
alias k9='kill -9'
alias k9a='killall -9'
alias pk='pkill'
alias pk9='pkill -9'

alias s='sudo -E'
alias se='sudo -E nvim'

alias a='sudo apt'
alias ai='sudo apt install'
alias aa='sudo apt autoremove'
alias ac='sudo apt clean'
alias ar='sudo apt remove'
alias au='sudo apt update'
alias aug='sudo apt upgrade'
alias augd='sudo apt upgrade --dry-run'
alias augy='sudo apt upgrade --yes'
alias augyd='sudo apt upgrade --yes --dry-run'
alias augc='sudo apt upgrade --yes --with-new-pkgs'
alias augcd='sudo apt upgrade --yes --with-new-pkgs --dry-run'
alias augcy='sudo apt upgrade --yes --with-new-pkgs'
alias augcyd='sudo apt upgrade --yes --with-new-pkgs --dry-run'

alias qwe='setxkbmap -layout us -variant colemak_dh'
alias qwf='setxkbmap -layout us'

alias notes='nvim ~/Obsidian/index.md'
