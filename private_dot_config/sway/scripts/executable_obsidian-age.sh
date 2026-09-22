#!/usr/bin/env bash
# Elapsed time since today's Obsidian daily note was last modified.

file="$HOME/Obsidian/Daily/$(date +%Y)/$(date +%m)/$(date +%Y-%m-%d).md"

if [[ ! -f "$file" ]]; then
  printf '󰛌 --\n'
  exit 0
fi

elapsed=$(( $(date +%s) - $(stat -c %Y "$file") ))

if (( elapsed < 60 )); then
  printf '  %ds\n' "$elapsed"
elif (( elapsed < 3600 )); then
  printf '  %dm\n' "$(( elapsed / 60 ))"
else
  printf '  %dh %dm\n' "$(( elapsed / 3600 ))" "$(( elapsed % 3600 / 60 ))"
fi
