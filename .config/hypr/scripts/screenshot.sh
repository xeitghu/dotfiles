#!/bin/bash

# --- Опции для Wofi ---
options=" Area (Copy)\n Area (Edit)\n Window (Copy)\n Window (Edit)\n󰍹 Screen (Copy)\n󰍹 Screen (Edit)"

# --- Вызов Wofi ---
choice=$(echo -e "$options" | wofi --dmenu --prompt "Screenshot" --width 300 --height 250)

# --- Логика выбора ---
case "$choice" in
" Area (Copy)")
  grim /tmp/screenshot_full.png
  imv -f /tmp/screenshot_full.png &
  IMV_PID=$!
  sleep 0.3
  GEOMETRY=$(slurp)
  kill $IMV_PID
  sleep 0.5
  if [ -n "$GEOMETRY" ]; then
    grim -g "$GEOMETRY" - | wl-copy
    notify-send "Screenshot Copied" "Selected area copied to clipboard." -i "camera-photo"
  fi
  rm /tmp/screenshot_full.png
  ;;
" Area (Edit)")
  grim /tmp/screenshot_full.png
  imv -f /tmp/screenshot_full.png &
  IMV_PID=$!
  sleep 0.3
  GEOMETRY=$(slurp)
  kill $IMV_PID
  sleep 0.5
  if [ -n "$GEOMETRY" ]; then
    grim -g "$GEOMETRY" - | swappy -f -
  fi
  rm /tmp/screenshot_full.png
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
