#!/usr/bin/env bash
# Robust waybar launcher for sway.
# - Locked to a single sway instance (lock file keyed by the sway PID).
# - Exits when its sway instance ends, so a new session can relaunch it.
# - Restarts waybar if it crashes. Logs to ~/.local/share/waybar.log.

log="$HOME/.local/share/waybar.log"
mkdir -p "$(dirname "$log")"

# The sway instance we were launched under; its SWAYSOCK is inherited.
sway_pid=$(pgrep -x sway | head -1)
[ -n "$sway_pid" ] || exit 0
[ -n "${SWAYSOCK:-}" ] || exit 0

lock="${XDG_RUNTIME_DIR:-/tmp}/waybar-launcher.${sway_pid}.lock"
exec 9>"$lock"
if ! flock -n 9; then
    exit 0
fi

printf '\n=== waybar (re)start %s (sway %s) ===\n' "$(date '+%F %T')" "$sway_pid" >>"$log"

pkill -x waybar 2>/dev/null
sleep 1

while true; do
    if ! kill -0 "$sway_pid" 2>/dev/null; then
        printf '=== sway %s gone, exiting %s ===\n' "$sway_pid" "$(date '+%F %T')" >>"$log"
        exit 0
    fi
    waybar >>"$log" 2>&1
    printf '=== waybar exited (%s), restarting ===\n' "$(date '+%F %T')" >>"$log"
    sleep 2
done
