#!/usr/bin/env bash
# Get backlight percentage using brightnessctl
brightnessctl info | grep -oP '\d+(?=%)' || echo "0"
