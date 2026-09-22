#!/usr/bin/env bash
exec /usr/bin/kitty --title "disk usage" -e /bin/sh -c 'df -h; printf "\nPress Enter to close... "; read -r'
