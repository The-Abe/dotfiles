#!/usr/bin/env bash

log=/tmp/polybar-btop.log
printf '%s invoked: DISPLAY=%s WAYLAND_DISPLAY=%s\n' "$(date '+%F %T')" "${DISPLAY:-}" "${WAYLAND_DISPLAY:-}" >>"$log"
$HOME/.cargo/bin/alacritty --title btop --command /usr/bin/btop >>"$log" 2>&1 &
printf '%s started pid=%s\n' "$(date '+%F %T')" "$!" >>"$log"
