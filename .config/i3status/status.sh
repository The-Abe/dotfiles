#!/bin/bash
i3status | while :
do
    read line
    echo "${line} " || exit 1
done
