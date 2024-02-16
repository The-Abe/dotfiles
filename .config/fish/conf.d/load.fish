[ -e "$HOME/.cargo/env" ] && . "$HOME/.cargo/env"
[ -e "$HOME/.asdf/asdf.sh" ] && . "$HOME/.asdf/asdf.fish"
[ -x /usr/bin/rbenv ] && [ -z "$RBENV_SHELL" ] && eval "$(rbenv init -)"
