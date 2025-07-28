#!/bin/bash

SCREENSHOT_DIR="$HOME/Pictures/Screenshots"
mkdir -p "$SCREENSHOT_DIR"

FILE_NAME="window_$(date +'%Y-%m-%d_%H-%M-%S').png"
FILE_PATH="$SCREENSHOT_DIR/$FILE_NAME"

GEOMETRY=$(hyprctl -j activewindow | jq -r '"\(.at[0]),\(.at[1]) \(.size[0])x\(.size[1])"')

grim -g "$GEOMETRY" "$FILE_PATH" && wl-copy < "$FILE_PATH"

notify-send "Screenshot Taken" "Active window copied to clipboard." -i "$FILE_PATH"
