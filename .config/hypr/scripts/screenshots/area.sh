#!/bin/bash

SCREENSHOT_DIR="$HOME/Pictures/Screenshots"
mkdir -p "$SCREENSHOT_DIR"

FILE_NAME="area_$(date +'%Y-%m-%d_%H-%M-%S').png"
FILE_PATH="$SCREENSHOT_DIR/$FILE_NAME"
TMP_FILE="/tmp/screenshot_frozen.png"

# Гарантированная очистка временного файла
trap 'rm -f "$TMP_FILE"' EXIT

# 1. Делаем полный скриншот во временный файл.
grim "$TMP_FILE"

# 2. Открываем его в imv для выбора области.
imv -f "$TMP_FILE" &
IMV_PID=$!
sleep 0.3

# 3. Запускаем slurp поверх изображения.
GEOMETRY=$(slurp)

# 4. Убиваем imv.
kill $IMV_PID

# 5. Если область не выбрана, выходим.
if [ -z "$GEOMETRY" ]; then
  exit 0
fi

# 6. ★★★ НОВАЯ СТРОКА ★★★
#    Преобразуем геометрию из "X,Y WxH" в "WxH+X+Y".
CROP_GEOMETRY=$(echo "$GEOMETRY" | sed -E 's/([0-9]+),([0-9]+) ([0-9]+x[0-9]+)/\3+\1+\2/')

# 7. Вырезаем выбранную область, используя уже правильный формат.
convert "$TMP_FILE" -crop "$CROP_GEOMETRY" "$FILE_PATH"

# 8. Копируем результат в буфер и отправляем уведомление.
wl-copy <"$FILE_PATH"
notify-send "Screenshot Taken" "Area saved and copied to clipboard." -i "$FILE_PATH"
