#!/bin/bash
SCREENSHOT_DIR="$HOME/Pictures/Screenshots"
mkdir -p "$SCREENSHOT_DIR"
FILE_PATH="$SCREENSHOT_DIR/$(date +'%Y-%m-%d_%H-%M-%S')-area.png"
grim -g "$(slurp)" "$FILE_PATH"
swappy -f "$FILE_PATH"
