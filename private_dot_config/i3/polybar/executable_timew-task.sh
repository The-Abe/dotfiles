#!/usr/bin/env bash
# Polybar module: current Timewarrior task + duration, or "idle".
# Colour is set inline so active/idle can differ.

fmt_duration() {
    local d="${1#P}" days=0 hours=0 mins=0
    [[ "$d" == *D* ]] && { days="${d%%D*}"; d="${d#*D}"; }
    d="${d#T}"
    [[ "$d" == *H* ]] && { hours="${d%%H*}"; d="${d#*H}"; }
    [[ "$d" == *M* ]] && mins="${d%%M*}"

    if   (( days  > 0 )); then printf "%dd%dh"  "$days"  "$hours"
    elif (( hours > 0 )); then printf "%dh%02dm" "$hours" "$mins"
    else                       printf "%dm"      "$mins"
    fi
}

if timew get dom.active 2>/dev/null | grep -q '^1$'; then
    tag=$(timew get dom.active.tag.1 2>/dev/null)
    dur=$(fmt_duration "$(timew get dom.active.duration 2>/dev/null)")
    printf '%%{F#50fa7b}%s %s%%{F-}\n' "$tag" "$dur"
else
    printf '%%{F#FF5555}idle%%{F-}\n'
fi
