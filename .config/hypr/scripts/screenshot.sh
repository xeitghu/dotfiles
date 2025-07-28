#!/bin/bash

# Директория для сохранения
SCREENSHOT_DIR="$HOME/Pictures/Screenshots"
mkdir -p "$SCREENSHOT_DIR"

# Имя файла с датой
FILE_NAME="$(date +'%Y-%m-%d_%H-%M-%S').png"
FILE_PATH="$SCREENSHOT_DIR/$FILE_NAME"

# --- Меню Wofi ---
# Добавляем новую опцию "Edit" с иконкой кисти 
options="󰆞 Area (Copy)\n󰹑 Window (Copy)\n󰍹 Screen (Copy)\n Edit (Select Area)"

choice=$(echo -e "$options" | wofi --dmenu --prompt "Screenshot" --width 250 --height 220)

# --- Логика выбора ---
case "$choice" in
    "󰆞 Area (Copy)")
        # Вызываем наш улучшенный скрипт для копирования области
        ~/.config/hypr/scripts/screenshot_area.sh
        ;;

    "󰹑 Window (Copy)")
        # Вызываем наш улучшенный скрипт для копирования окна
        ~/.config/hypr/scripts/screenshot_window.sh
        ;;

    "󰍹 Screen (Copy)")
        # Делаем скриншот всего экрана, копируем и уведомляем
        grim "$FILE_PATH" && wl-copy < "$FILE_PATH"
        notify-send "Screenshot Taken" "Fullscreen copied to clipboard." -i "$FILE_PATH"
        ;;

    " Edit (Select Area)")
        # Старый, добрый способ: выделить область и СРАЗУ открыть в swappy
        # Мы используем пайп, чтобы не создавать временный файл
        grim -g "$(slurp)" - | swappy -f -
        ;;
    *)
        # Если нажали Esc, выходим
        exit 0
        ;;
esac
