#!/usr/bin/env bash
# Polybar module: today's total Timewarrior tracked time.
# Outputs nothing when no time has been tracked yet today.

total=$(timew summary :day 2>/dev/null | grep -oP '[0-9]+:[0-9]+:[0-9]+$' | tail -1)
[[ -n "$total" ]] && echo "Total: ${total}"
