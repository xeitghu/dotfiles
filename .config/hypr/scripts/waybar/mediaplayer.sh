#!/bin/bash
# ┌──────────────────────────────────┐
# │    WAYBAR - PLAYERCTL WRAPPER    │
# └──────────────────────────────────┘

# [INFO] This script now relies on playerctld to manage the active
# player, making it much simpler and more reliable.

PLAYER_STATUS=$(playerctl status 2>/dev/null)

if [ -n "$PLAYER_STATUS" ]; then
  TEXT=$(playerctl metadata --format "{{ title }}")

  if [ "$PLAYER_STATUS" = "Playing" ]; then
    ICON=""
  elif [ "$PLAYER_STATUS" = "Paused" ]; then
    ICON=""
  else
    ICON="⏹"
  fi
else
  ICON="⏹"
  TEXT="Nothing Playing"
fi

# --- JSON Output ---
jq -n -c \
  --arg icon "$ICON" \
  --arg text "$TEXT" \
  '{"text": $text, "tooltip": $text, "alt": $icon}'
