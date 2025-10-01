#!/bin/bash

# ┌──────────────────────────────────────────────────┐
# │            Dunst Notification History            │
# └──────────────────────────────────────────────────┘
# [INFO] This script displays the Dunst notification history using Wofi.

# --- Get and Format History ---
# [INFO] 'dunstctl history -j' gets history in JSON format.
# [INFO] 'jq' parses the JSON and formats each notification as "Summary: Body".
HISTORY=$(dunstctl history -j | jq -r '.data[0][] | .summary.data + ": " + .body.data')

# --- Show Wofi Menu ---
# [FIX] Only show Wofi if there is history to display.
if [ -n "$HISTORY" ]; then
  echo "$HISTORY" | wofi --dmenu --prompt "Notifications" --width 50% --height 60%
else
  notify-send "Notification History" "No history available." -i "dialog-information"
fi
