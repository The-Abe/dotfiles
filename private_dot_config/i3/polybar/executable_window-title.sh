#!/usr/bin/env bash

# 1. Fallback if MONITOR environment variable is missing
if [ -z "$MONITOR" ]; then
  MONITOR=$(i3-msg -t get_outputs | jq -r '.[] | select(.focused).name')
fi

# Fetch workspaces state
WORKSPACES=$(i3-msg -t get_workspaces)

# 2. Get the exact workspace name currently visible on THIS specific monitor
ACTIVE_WS_NAME=$(echo "$WORKSPACES" | jq -r --arg mon "$MONITOR" '.[] | select(.output == $mon and .visible == true) | .name')

if [ -z "$ACTIVE_WS_NAME" ] || [ "$ACTIVE_WS_NAME" = "null" ]; then
  echo " %{F#4C566A}Empty Workspace%{F-}"
  exit 0
fi

# 3. Pull the i3 tree layout to extract the window title
TREE=$(i3-msg -t get_tree)

# 4. Find all client windows inside THIS specific workspace.
# We isolate this workspace node from the tree and safely extract the window title.
# If a window is globally focused here, use it. Otherwise, pull the first visible application window.

FOCUS_ID=$(echo "$TREE" | jq -r --arg ws "$ACTIVE_WS_NAME" '
  .. | select(.type? == "workspace" and .name == $ws).focus[0]
' 2>/dev/null | head -n 1)

WIN_TITLE=""
DEPTH=0
MAX_DEPTH=10 # Prevent infinite loops in case of malformed tree

while [ ! -z "$FOCUS_ID" ] && [ "$FOCUS_ID" != "null" ] && [ "$DEPTH" -lt "$MAX_DEPTH" ]; do
    ((DEPTH++))
    # Try to grab a window title for the current node ID
    WIN_TITLE=$(echo "$TREE" | jq -r --arg fid "$FOCUS_ID" '
      .. | select(.id? == ($fid|tonumber)).window_properties.title // empty
    ' 2>/dev/null | head -n 1)

    # If we found a real title, break out!
    [ ! -z "$WIN_TITLE" ] && break

    # Otherwise, this node is a layout container. Drop down to its first child.
    FOCUS_ID=$(echo "$TREE" | jq -r --arg fid "$FOCUS_ID" '
      .. | select(.id? == ($fid|tonumber)).focus[0] // empty
    ' 2>/dev/null | head -n 1)
done

# 5. Apply colors based on whether this monitor's workspace has global user focus
if [ ! -z "$WIN_TITLE" ] && [ "$WIN_TITLE" != "null" ] && [ "$WIN_TITLE" != "" ]; then
  # Grab the globally focused workspace name instantly from your clean JSON layout
  GLOBAL_FOCUS_WS=$(echo "$WORKSPACES" | jq -r '.[] | select(.focused == true) | .name')

  if [ "$ACTIVE_WS_NAME" = "$GLOBAL_FOCUS_WS" ]; then
    echo " %{F#88C0D0}$WIN_TITLE%{F-}" # Nord cyan: focused
  else
    echo " %{F#4C566A}$WIN_TITLE%{F-}" # Nord gray: unfocused
  fi
else
  echo " %{F#4C566A}Empty Workspace%{F-}"
fi
