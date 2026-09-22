#!/usr/bin/env bash
set -u

# Feed cliphist from the X11 clipboard using xclip. Polls once a second and
# stores new text or PNG image entries as they appear.
last=""
while true; do
    if xclip -selection clipboard -o -target TARGETS 2>/dev/null | grep -qx "image/png"; then
        sig="$(xclip -selection clipboard -o -target image/png 2>/dev/null | md5sum)"
        kind="image"
    else
        sig="$(xclip -selection clipboard -o 2>/dev/null | md5sum)"
        kind="text"
    fi

    if [[ -n "$sig" && "$sig" != "$last" ]]; then
        if [[ "$kind" == "image" ]]; then
            xclip -selection clipboard -o -target image/png 2>/dev/null | cliphist store
        else
            xclip -selection clipboard -o 2>/dev/null | cliphist store
        fi
        last="$sig"
    fi
    sleep 1
done
