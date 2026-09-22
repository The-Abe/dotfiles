#!/usr/bin/env bash
monitor="${1:-$MONITOR}"

ws=$(i3-msg -t get_workspaces | jq -r --arg mon "$monitor" '
  .[] | select(.output == $mon and .visible == true) | .name
' | head -1)

[ -z "$ws" ] && exit

i3-msg -t get_tree | jq -r --arg ws "$ws" '
  ..
  | select(.type? == "workspace" and .name? == $ws)
  | recurse(
      .focus[0] as $fid
      | (.nodes + .floating_nodes)[]
      | select(.id == $fid)
    )
  | select(.window_properties?.class?)
  | .name
' | head -1 | perl -CSD -pe 's/\p{Emoji}|\p{Emoji_Presentation}|\p{Emoji_Modifier}|\p{Emoji_Modifier_Base}|\p{Emoji_Component}//g'
