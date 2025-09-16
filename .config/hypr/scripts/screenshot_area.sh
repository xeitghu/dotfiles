#!/bin/bash

SCREENSHOT_DIR="$HOME/Pictures/Screenshots"
mkdir -p "$SCREENSHOT_DIR"

FILE_NAME="area_$(date +'%Y-%m-%d_%H-%M-%S').png"
FILE_PATH="$SCREENSHOT_DIR/$FILE_NAME"

# 1. Делаем полный скриншот и сохраняем его во временный файл.
grim /tmp/screenshot_full.png

# 2. Открываем этот скриншот в полноэкранном режиме с помощью imv.
#    Он становится нашим статичным фоном. Запускаем в фоне (&).
imv -f /tmp/screenshot_full.png &
IMV_PID=$! # Запоминаем ID процесса imv, чтобы потом его "убить".

# 3. Даем imv долю секунды, чтобы он успел открыться.
sleep 0.3

# 4. Запускаем slurp поверх полноэкранного изображения.
GEOMETRY=$(slurp)

# 5. Немедленно убиваем процесс imv, как только область выбрана (или отменена).
kill $IMV_PID
sleep 0.5

# 6. Если область не выбрана (нажат Escape), выходим и чистим за собой.
if [ -z "$GEOMETRY" ]; then
  rm /tmp/screenshot_full.png
  exit 0
fi

# 7. Делаем финальный снимок по координатам с реального экрана.
grim -g "$GEOMETRY" "$FILE_PATH"

# 8. Копируем в буфер и отправляем уведомление.
wl-copy <"$FILE_PATH"
notify-send "Screenshot Taken" "Area saved and copied to clipboard." -i "$FILE_PATH"

# 9. Чистим временный файл.
rm /tmp/screenshot_full.png
