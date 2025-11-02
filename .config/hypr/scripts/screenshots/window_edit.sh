#!/bin/bash
# ┌─────────────────────────────────────┐
# │         SCREENSHOT - WINDOW         │
# └─────────────────────────────────────┘

# --- Capture & Edit ---
# [INFO] Get the active window's geometry.
GEOMETRY=$(hyprctl -j activewindow | jq -r '"\(.at[0]),\(.at[1]) \(.size[0])x\(.size[1])"')

# [INFO] Take the screenshot and pipe it directly into the swappy editor.
grim -g "$GEOMETRY" - | swappy -f -
