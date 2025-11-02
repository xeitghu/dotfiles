#!/bin/bash
# ┌──────────────────────────────────────────────┐
# │              SCREENSHOT - MENU               │
# └──────────────────────────────────────────────┘

# --- Wofi Configuration ---
# [CONFIG] Wofi window settings.
wofi_command="wofi --dmenu --prompt=Screenshot --width=300 --height=250"

# --- Options ---
# [CONFIG] Options to display in the Wofi menu.
options=" Area (Copy)
 Area (Edit)
 Window (Copy)
 Window (Edit)
󰍹 Screen (Copy)
󰍹 Screen (Edit)"

# --- Main Logic ---
# [INFO] Display the menu and capture the user's choice.
choice=$(echo -e "$options" | ${wofi_command})

# [INFO] Execute the corresponding action based on the choice.
case "$choice" in
" Area (Copy)")
  ~/.config/hypr/scripts/screenshots/_capture.sh | wl-copy
  notify-send "Screenshot Copied" "Selected area copied." -i "camera-photo"
  ;;
" Area (Edit)")
  ~/.config/hypr/scripts/screenshots/_capture.sh | swappy -f -
  ;;
" Window (Copy)")
  grim -g "$(hyprctl -j activewindow | jq -r '"\(.at[0]),\(.at[1]) \(.size[0])x\(.size[1])"')" - | wl-copy
  notify-send "Screenshot Copied" "Active window copied." -i "camera-photo"
  ;;
" Window (Edit)")
  grim -g "$(hyprctl -j activewindow | jq -r '"\(.at[0]),\(.at[1]) \(.size[0])x\(.size[1])"')" - | swappy -f -
  ;;
"󰍹 Screen (Copy)")
  grim - | wl-copy
  notify-send "Screenshot Copied" "Fullscreen copied." -i "camera-photo"
  ;;
"󰍹 Screen (Edit)")
  grim - | swappy -f -
  ;;
esac
