#!/bin/bash
# ┌────────────────────────────────────────────┐
# │             SCREENSHOT - AREA              │
# └────────────────────────────────────────────┘

# [INFO] This script now acts as a simple caller for the main capture engine.
# It captures an area, saves it to a file, and copies it to the clipboard.

# --- Configuration ---
# [CONFIG] Directory where screenshots will be saved.
SCREENSHOT_DIR="$HOME/Pictures/Screenshots"

# --- Initialization ---
# [INFO] Ensure the target directory exists.
mkdir -p "$SCREENSHOT_DIR"

# --- Main Logic ---
# [INFO] 1. Call the capture engine, which outputs PNG data.
# [INFO] 2. 'tee' duplicates the data: one copy goes to a new file, the other to stdout.
# [INFO] 3. 'wl-copy' reads from stdout and puts the image on the clipboard.
# [INFO] 4. If successful, send a notification.
~/.config/hypr/scripts/screenshots/_capture.sh | tee "$SCREENSHOT_DIR/area_$(date +'%Y-%m-%d_%H-%M-%S').png" | wl-copy &&
  notify-send "Screenshot Taken" "Area saved and copied." -i "camera-photo"
