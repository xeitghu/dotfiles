#!/bin/bash

# --- Опции для Wofi (теперь 6 вариантов) ---
options=" Area (Copy)\n Area (Edit)\n Window (Copy)\n Window (Edit)\n󰍹 Screen (Copy)\n󰍹 Screen (Edit)"

# --- Вызов Wofi (увеличим размер под 6 опций) ---
choice=$(echo -e "$options" | wofi --dmenu --prompt "Screenshot" --width 300 --height 250)

# --- Логика выбора (объединяем и улучшаем вашу логику) ---
case "$choice" in
    " Area (Copy)")
        grim -g "$(slurp)" - | wl-copy
        notify-send "Screenshot Copied" "Selected area copied to clipboard." -i "camera-photo"
        ;;
    " Area (Edit)")
        grim -g "$(slurp)" - | swappy -f -
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
