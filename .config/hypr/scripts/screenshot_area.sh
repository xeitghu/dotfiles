#!/bin/bash

SCREENSHOT_DIR="$HOME/Pictures/Screenshots"
mkdir -p "$SCREENSHOT_DIR"

FILE_NAME="area_$(date +'%Y-%m-%d_%H-%M-%S').png"
FILE_PATH="$SCREENSHOT_DIR/$FILE_NAME"

geometry=$(slurp)

if [ -z "$geometry" ]; then
    exit 0
fi

grim -g "$geometry" "$FILE_PATH" && wl-copy < "$FILE_PATH"

notify-send "Screenshot Taken" "Area copied to clipboard." -i "$FILE_PATH"
