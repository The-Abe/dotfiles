#!/bin/sh
# Status line derived from the zsh PROMPT: yellow cwd, cyan git branch, magenta time,
# plus model and context usage.
input=$(cat)
dir=$(echo "$input" | jq -r '.workspace.current_dir // .cwd')
short=$(printf '%s' "$dir" | sed "s|^$HOME|~|")

branch=$(git -C "$dir" --no-optional-locks symbolic-ref --short HEAD 2>/dev/null \
  || git -C "$dir" --no-optional-locks rev-parse --short HEAD 2>/dev/null)

printf '\033[33m%s\033[0m' "$short"
[ -n "$branch" ] && printf ' \033[36m(%s)\033[0m' "$branch"
printf ' \033[35m%s\033[0m' "$(date +%H:%M:%S)"

model=$(echo "$input" | jq -r '.model.display_name // empty')
[ -n "$model" ] && printf ' \033[32m%s\033[0m' "$model"

used=$(echo "$input" | jq -r '.context_window.used_percentage // empty')
if [ -n "$used" ]; then
  used=${used%.*}
  if [ "$used" -ge 80 ]; then c=31; elif [ "$used" -ge 50 ]; then c=33; else c=90; fi
  printf ' \033[%sm%s%%\033[0m' "$c" "$used"
fi
