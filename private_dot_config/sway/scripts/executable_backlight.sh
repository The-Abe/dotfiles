#!/usr/bin/env bash
# Backlight percentage via brightnessctl.
brightnessctl info | grep -oP '\d+(?=%)' || echo "0"
