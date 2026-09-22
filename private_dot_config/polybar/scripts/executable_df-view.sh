#!/usr/bin/env bash

exec kitty --title "disk usage" /bin/sh -c 'df -h; printf "\nPress Enter to close... "; read -r'
