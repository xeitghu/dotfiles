#!/bin/bash
# ===============================================================
#         PYRE NEXT WALLPAPER (v2.0 - УМНАЯ ВЕРСИЯ)
# ===============================================================
STATE_FILE="$HOME/.config/pyre/state"
WALLPAPER_BASE_DIR="$HOME/Pictures/Wallpapers"

# Читаем текущее состояние
current_state=$(cat "$STATE_FILE")

# ЕСЛИ мы в режиме случайных обоев
if [ "$current_state" == "random" ]; then
    # Просто вызываем основную функцию из главного скрипта
    /home/x8u/.local/bin/pyre wallpaper
# ИНАЧЕ (если у нас активна статическая тема)
else
    theme_wallpaper_dir="$WALLPAPER_BASE_DIR/$(echo "$current_state" | tr '[:upper:]' '[:lower:]')"
    
    if [ -d "$theme_wallpaper_dir" ]; then
        wallpaper=$(find "$theme_wallpaper_dir" -type f | shuf -n 1)
        if [ -n "$wallpaper" ]; then
            # Просто меняем обои с красивой анимацией, не трогая тему
            swww img "$wallpaper" \
                --transition-type grow \
                --transition-pos 0.5,0.5 \
                --transition-duration 1.2 \
                --transition-fps 60
        fi
    fi
fi
