#!/usr/bin/env bash
set -euo pipefail

# Show clipboard history (backed by cliphist) and copy the selection with xclip.
selection="$(cliphist list | rofi -dmenu -i -p "Clipboard" -theme "$HOME/.config/rofi/config-clipboard.rasi")"
if [[ -z "$selection" ]]; then
    exit 0
fi

id="${selection%%$'\t'*}"
tmp="$(mktemp)"
trap 'rm -f "$tmp"' EXIT
cliphist decode "$id" > "$tmp"

# Copy PNG images with the image target, everything else as plain text.
if [[ "$(head -c 8 "$tmp" | od -An -tx1 | tr -d ' \n')" == "89504e470d0a1a0a" ]]; then
    xclip -selection clipboard -target image/png -i "$tmp"
else
    xclip -selection clipboard -i "$tmp"
fi
