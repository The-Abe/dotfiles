#!/usr/bin/env bash
# Window title for waybar custom module (sway).
# Shows the globally-focused window's title; pango markup for color.

title=$(swaymsg -t get_tree 2>/dev/null \
    | jq -r '.. | objects | select(.focused == true and .type == "con") | .name // empty' \
    | head -1)

if [ -n "$title" ]; then
    printf '<span color="#83a598">%s</span>\n' "$title"
else
    printf '<span color="#928374">empty</span>\n'
fi
