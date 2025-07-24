#!/bin/bash

SCREENSHOT_DIR="$HOME/Pictures/Screenshots"
mkdir -p "$SCREENSHOT_DIR"

options=" Area\n Window\n󰍹 Screen"
choice=$(echo -e "$options" | wofi --dmenu --prompt "Take Screenshot" --width 250 --height 180)

# Генерируем имя файла здесь, до case
FILE_PATH="$SCREENSHOT_DIR/$(date +'%Y-%m-%d_%H-%M-%S')-menu.png"

case ${choice} in
    " Area")
        grim -g "$(slurp)" "$FILE_PATH"
        ;;
    " Window")
        GEOMETRY=$(hyprctl -j activewindow | jq -r '"\(.at[0]),\(.at[1]) \(.size[0])x\(.size[1])"')
        grim -g "$GEOMETRY" "$FILE_PATH"
        ;;
    "󰍹 Screen")
        grim "$FILE_PATH"
        ;;
    *)
        # Если нажали Esc в wofi, то просто выходим, не создавая пустой файл
        exit 0
        ;;
esac

# Открываем только что созданный файл в swappy
if [ -f "$FILE_PATH" ]; then
    swappy -f "$FILE_PATH"
fi
