#!/usr/bin/env bash
# Power menu (wlogout). Its default actions are sway-oriented:
# lock -> swaylock, logout -> swaymsg exit.

if pgrep -x "wlogout" > /dev/null; then
    pkill -x "wlogout"
    exit 0
fi

exec wlogout --protocol layer-shell -l /etc/wlogout/layout -C /etc/wlogout/style.css -c 10 -r 10
