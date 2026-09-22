#!/usr/bin/env bash

set -euo pipefail

if [[ "${1:-}" == toggle ]]; then
  powered=$(bluetoothctl show | awk -F': ' '/Powered:/ {print $2; exit}')
  if [[ "$powered" == yes ]]; then
    bluetoothctl power off >/dev/null
  else
    bluetoothctl power on >/dev/null
  fi
  exit 0
fi

powered=$(bluetoothctl show | awk -F': ' '/Powered:/ {print $2; exit}')
if [[ "$powered" != yes ]]; then
  printf ' off\n'
  exit 0
fi

connected=$(bluetoothctl devices Connected | awk 'END { print NR + 0 }')
if (( connected > 0 )); then
  printf ' %d\n' "$connected"
else
  printf ' ready\n'
fi
