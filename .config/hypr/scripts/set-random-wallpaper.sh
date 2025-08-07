#!/bin/bash

# --- КОНФИГУРАЦИЯ ---
# Путь к вашей главной папке с обоями.
WALLPAPER_DIR="$HOME/Pictures/Wallpapers"

# Параметры анимации для swww v0.10.3
TRANSITION_TYPE="random"
TRANSITION_STEP=90
TRANSITION_FPS=60

# --- ЛОГИКА СКРИПТА ---

# 1. Проверка, существует ли папка.
if [ ! -d "$WALLPAPER_DIR" ]; then
  echo "Ошибка: Директория '$WALLPAPER_DIR' не найдена."
  exit 1
fi

# 2. Поиск случайного файла изображения.
wallpaper=$(find "$WALLPAPER_DIR" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.gif" \) | shuf -n 1)

# 3. Проверка, было ли найдено изображение.
if [ -z "$wallpaper" ]; then
  echo "Ошибка: В директории '$WALLPAPER_DIR' не найдено изображений."
  exit 1
fi

# 4. Установка обоев (команда БЕЗ 'img').
swww "$wallpaper" \
    --transition-type "$TRANSITION_TYPE" \
    --transition-step "$TRANSITION_STEP" \
    --transition-fps "$TRANSITION_FPS"
