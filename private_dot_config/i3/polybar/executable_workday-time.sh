#!/usr/bin/env bash
# Polybar module: 10-block workday progress bar + remaining/clock.
# Reads work hours from workhours.conf (same file the old status script used).

WORKHOURS="${XDG_CONFIG_HOME:-$HOME/.config}/i3/workhours.conf"

to_minutes() {
    local t="$1"
    if [[ "$t" == *:* ]]; then
        printf '%d' $(( 10#${t%%:*} * 60 + 10#${t##*:} ))
    else
        printf '%d' $(( 10#$t * 60 ))
    fi
}

fmt_hhmmss() {
    local s=$(( $1 < 0 ? -$1 : $1 ))
    printf '%02d:%02d:%02d' $(( s / 3600 )) $(( s % 3600 / 60 )) $(( s % 60 ))
}

# Load work hours — done here (not in a subshell) so variables stay in scope
WORK_START_MIN="" WORK_END_MIN=""
if [[ -f "$WORKHOURS" ]]; then
    source "$WORKHOURS"
    day=$(LC_ALL=C date +%a | tr '[:lower:]' '[:upper:]')
    sv="${day}_START"; ev="${day}_END"
    [[ -n "${!sv}" && -n "${!ev}" ]] && \
        WORK_START_MIN=$(to_minutes "${!sv}") && \
        WORK_END_MIN=$(to_minutes "${!ev}")
fi

now_str=$(date +'%H:%M:%S')
now_sec=$(( 10#$(date +%H) * 3600 + 10#$(date +%M) * 60 + 10#$(date +%S) ))
now_min=$(( now_sec / 60 ))

if [[ -n "$WORK_START_MIN" && -n "$WORK_END_MIN" ]]; then
    filled=0
    (( now_min > WORK_START_MIN && now_min < WORK_END_MIN )) && \
        filled=$(( (now_min - WORK_START_MIN) * 20 / (WORK_END_MIN - WORK_START_MIN) ))
    (( now_min >= WORK_END_MIN )) && filled=20

    bar=""
    for (( i=0; i<filled;  i++ )); do bar="${bar}█"; done
    for (( i=filled; i<20; i++ )); do bar="${bar} "; done

    remaining=$(( WORK_END_MIN * 60 - now_sec ))
    if (( remaining > 0 )); then
        rem_str="-$(fmt_hhmmss $remaining)"
    else
        rem_str="+$(fmt_hhmmss $remaining)"
    fi
    printf '[%s] %d%% %s/%s\n' "$bar" $(( filled * 5 )) "$rem_str" "$now_str"
else
    printf '%s\n' "$now_str"
fi
