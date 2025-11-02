#!/bin/bash
# ┌───────────────────────────────────────────────┐
# │              SCREENSHOT - WINDOW              │
# └───────────────────────────────────────────────┘

# --- Configuration ---
# [CONFIG] Directory where screenshots will be saved.
SCREENSHOT_DIR="$HOME/Pictures/Screenshots"

# --- Initialization ---
# [INFO] Ensure the target directory exists.
mkdir -p "$SCREENSHOT_DIR"

# [INFO] Define the file path.
FILE_NAME="window_$(date +'%Y-%m-%d_%H-%M-%S').png"
FILE_PATH="$SCREENSHOT_DIR/$FILE_NAME"

# --- Capture ---
# [INFO] Get the active window's geometry using hyprctl and jq.
GEOMETRY=$(hyprctl -j activewindow | jq -r '"\(.at[0]),\(.at[1]) \(.size[0])x\(.size[1])"')

# [INFO] Take the screenshot of the specified geometry.
grim -g "$GEOMETRY" "$FILE_PATH"

# --- Finalization ---
# [INFO] Copy the final image to clipboard and send a notification.
wl-copy <"$FILE_PATH"
notify-send "Screenshot Taken" "Active window saved and copied." -i "$FILE_PATH"
