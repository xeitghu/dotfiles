#!/bin/bash
SCREENSHOT_DIR="$HOME/Pictures/Screenshots"
mkdir -p "$SCREENSHOT_DIR"
FILE_PATH="$SCREENSHOT_DIR/$(date +'%Y-%m-%d_%H-%M-%S')-window.png"
GEOMETRY=$(hyprctl -j activewindow | jq -r '"\(.at[0]),\(.at[1]) \(.size[0])x\(.size[1])"')
grim -g "$GEOMETRY" "$FILE_PATH"
swappy -f "$FILE_PATH"
