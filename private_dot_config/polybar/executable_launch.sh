#!/usr/bin/env bash

# Polybar launch script
# Launches main bar on primary monitor and secondary bars on all other monitors

set -euo pipefail

DIR="$(cd "$(dirname "$0")" && pwd)"
CONFIG="$DIR/config.ini"
PRIMARY_MONITOR="${PRIMARY_MONITOR:-$(xrandr --query | grep ' primary' | awk '{print $1}')}"

# Kill existing polybar instances
killall -q polybar 2>/dev/null || true
while pgrep -x polybar >/dev/null; do sleep 0.5; done

# Collect non-primary monitors
MONITORS=()
while IFS= read -r line; do
  mon=$(echo "$line" | awk '{print $1}')
  if [[ "$mon" != "$PRIMARY_MONITOR" ]]; then
    MONITORS+=("$mon")
  fi
done < <(xrandr --query | grep ' connected' | grep -v '^[[:space:]]')

NUM_SECONDARY=${#MONITORS[@]}

# Launch main bar
MONITOR="$PRIMARY_MONITOR" polybar --config="$CONFIG" main &
echo "main  -> $PRIMARY_MONITOR"

# Launch secondary bars
for mon in "${MONITORS[@]}"; do
  MONITOR="$mon" polybar --config="$CONFIG" secondary &
  echo "secondary -> $mon"
done

echo "polybar: done ($((NUM_SECONDARY + 1)) bars launched)"
