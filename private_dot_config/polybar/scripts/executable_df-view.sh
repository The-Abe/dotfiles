#!/usr/bin/env bash

exec $HOME/.cargo/bin/alacritty --title "disk usage" --command /bin/sh -c 'df -h; printf "\nPress Enter to close... "; read -r'
