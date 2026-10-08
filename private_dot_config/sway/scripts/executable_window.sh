#!/usr/bin/env bash
# Window title for waybar custom module (sway).
# Shows the focused window on the bar's own output (WAYBAR_OUTPUT_NAME),
# found via the focus stack of that output's current workspace.
# Falls back to the globally focused window when run without waybar.

tree=$(swaymsg -t get_tree 2>/dev/null)

if [ -z "$tree" ]; then
    printf '<span color="#928374">empty</span>\n'
    exit 0
fi

title=$(jq -r --arg out "${WAYBAR_OUTPUT_NAME:-}" '
    def descend:
        . as $n
        | (($n.nodes // []) + ($n.floating_nodes // [])) as $kids
        | if ($kids | length) == 0 then $n
          elif (($n.focus // []) | length) == 0 then $kids[0] | descend
          else ($n.focus[0]) as $f
            | ([$kids[] | select(.id == $f)] | first) as $c
            | if $c == null then $kids[0] | descend else $c | descend end
          end;

    if $out != "" then
        (.nodes[] | select(.type == "output" and .name == $out) | .current_workspace) as $cws
        | ([.nodes[] | select(.type == "output")
            | .nodes[] | select(.type == "workspace" and .name == $cws)] | first)
        | if . == null then empty else descend | select(.type != "workspace") | .name // empty end
    else
        .. | objects | select(.focused == true and .type == "con") | .name // empty
    end
' <<<"$tree" | head -1)

if [ -n "$title" ]; then
    printf '<span color="#83a598">%s</span>\n' "$title"
else
    printf '<span color="#928374">empty</span>\n'
fi
