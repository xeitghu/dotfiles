#!/bin/bash
# ┌──────────────────────────────────────────────────┐
# │             SCREENSHOT - CAPTURE ENGINE            │
# └──────────────────────────────────────────────────┘

# [INFO] This is a library script. It is not meant to be called directly.
# It handles the screen freeze, selection, and outputs cropped image data.

# --- Initialization ---
TMP_FILE="/tmp/screenshot_frozen.png"
trap 'rm -f "$TMP_FILE"' EXIT

# --- Main Logic ---
grim "$TMP_FILE"
imv -f "$TMP_FILE" &
IMV_PID=$!
sleep 0.3
GEOMETRY=$(slurp)
kill $IMV_PID

if [ -z "$GEOMETRY" ]; then
  exit 1
fi

CROP_GEOMETRY=$(echo "$GEOMETRY" | sed -E 's/([0-9]+),([0-9]+) ([0-9]+x[0-9]+)/\3+\1+\2/')

# [CRITICAL] Output the final, cropped image data to stdout.
convert "$TMP_FILE" -crop "$CROP_GEOMETRY" png:-
