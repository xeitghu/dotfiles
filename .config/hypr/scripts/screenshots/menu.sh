#!/bin/bash

# --- Опции для Wofi ---
options=" Area (Copy)\n Area (Edit)\n Window (Copy)\n Window (Edit)\n󰍹 Screen (Copy)\n󰍹 Screen (Edit)"

# --- Временный файл ---
TMP_FILE="/tmp/screenshot_frozen.png"
trap 'rm -f "$TMP_FILE"' EXIT

# --- Вызов Wofi ---
choice=$(echo -e "$options" | wofi --dmenu --prompt "Screenshot" --width 300 --height 250)

# --- Логика выбора ---
case "$choice" in
" Area (Copy)")
  grim "$TMP_FILE"
  imv -f "$TMP_FILE" &
  IMV_PID=$!
  sleep 0.3
  GEOMETRY=$(slurp)
  kill $IMV_PID
  if [ -n "$GEOMETRY" ]; then
    CROP_GEOMETRY=$(echo "$GEOMETRY" | sed -E 's/([0-9]+),([0-9]+) ([0-9]+x[0-9]+)/\3+\1+\2/')
    convert "$TMP_FILE" -crop "$CROP_GEOMETRY" - | wl-copy
    notify-send "Screenshot Copied" "Selected area copied to clipboard." -i "camera-photo"
  fi
  ;;
" Area (Edit)")
  grim "$TMP_FILE"
  imv -f "$TMP_FILE" &
  IMV_PID=$!
  sleep 0.3
  GEOMETRY=$(slurp)
  kill $IMV_PID
  if [ -n "$GEOMETRY" ]; then
    CROP_GEOMETRY=$(echo "$GEOMETRY" | sed -E 's/([0-9]+),([0-9]+) ([0-9]+x[0-9]+)/\3+\1+\2/')
    convert "$TMP_FILE" -crop "$CROP_GEOMETRY" - | swappy -f -
  fi
  ;;
" Window (Copy)")
  grim -g "$(hyprctl -j activewindow | jq -r '"\(.at[0]),\(.at[1]) \(.size[0])x\(.size[1])"')" - | wl-copy
  notify-send "Screenshot Copied" "Active window copied to clipboard." -i "camera-photo"
  ;;
" Window (Edit)")
  grim -g "$(hyprctl -j activewindow | jq -r '"\(.at[0]),\(.at[1]) \(.size[0])x\(.size[1])"')" - | swappy -f -
  ;;
"󰍹 Screen (Copy)")
  grim - | wl-copy
  notify-send "Screenshot Copied" "Fullscreen copied to clipboard." -i "camera-photo"
  ;;
"󰍹 Screen (Edit)")
  grim - | swappy -f -
  ;;
esac
